<device-view>
    <div ref="container" class="scrarea">
        <div ref="grid" class="gridarea"></div>
    </div>
    <ndialog ref="dialog">
        <device-editor ref="editor"></device-editor>
    </ndialog>
    <style>
        :scope {
            position: relative;
            margin: 0;
            padding: 5px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1px 1fr 1px;
            grid-template-areas: 
                '.'
                'scrarea'
                '.';
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.scrarea {
            grid-area: scrarea;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'gridarea';
            margin: 0 auto;
            padding: 0;
            width: 100%;
            max-width: 800px;
            height: 100%;
            overflow: hidden;
            box-shadow: var(--default-box-shadow);
        }
        :scope>.scrarea>.gridarea {
            grid-area: gridarea;
            margin: 0 auto;
            padding: 0;
            height: 100%;
            width: 100%;
        }
        :scope>.scrarea>.gridarea.tabulator .tabulator-header .tabulator-frozen.tabulator-frozen-left {
            display: none; /* hide frozen left header */
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        let partId = 'device-view'
        this.content = {
            columns: [
                { title: 'Device Name', field: 'DeviceName', resizable: false },
                { title: 'Location', field: 'Location', resizable: false },
                { title: 'Type', field: 'Type', resizable: false }
            ]
        }

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let grid = null, datasource = []
        let dialog, editor
        let initCtrls = () => {
            dialog = self.refs['dialog']
            editor = (dialog) ? dialog.refs['editor'] : null
        }
        let freeCtrls = () => {
            dialog = null
            editor = null
            grid = null
        }
        let bindEvents = () => {
            addEvt(events.name.ContentChanged, onContentChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ContentChanged, onContentChanged)
        }
        let onContentChanged = () => { updateContents() }
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            // load columns
            if (partContent) {
                self.content.columns = partContent.columns
                // update grid.
                loadDataSource()
            }
        }
        let loadDataSource = () => {
            let langId = (lang.current) ? lang.current.langId : 'EN'
            let url = '/customers/api/devices'
            let paramObj = {}
            paramObj.langId = langId
            let fn = (r) => {
                let data = api.parse(r)
                datasource = (data.records && data.records[langId]) ? data.records[langId] : []
                updateGrid()
            }
            XHR.postJson(url, paramObj, fn)
        }
        let editIcon = (cell, formatterParams) => {
            return "<span class='fas fa-edit' style='font-weight:bold;'></span>";
        };
        let deleteIcon = (cell, formatterParams) => {
            return "<span class='fas fa-trash-alt' style='font-weight:bold;'></span>";
        };
        let updateGrid = () => {
            let el = self.refs['grid']
            if (el) {
                let gridColumns = []
                if (self.opts.viewonly !== 'true') {
                    gridColumns.push({
                        formatter: editIcon, hozAlign: "center", width: 30, 
                        resizable: false, frozen: true, headerSort: false,
                        cellClick: editRow
                    }, {
                        formatter: deleteIcon, hozAlign: "center", width: 30, 
                        resizable: false, frozen: true, headerSort: false,
                        cellClick: deleteRow
                    })
                }
                gridColumns.push(...self.content.columns)
                let opts = {
                    height: "100%",
                    layout: 'fitDataFill',
                    selectable: 1,
                    index: self.content.columns[0].field,
                    columns: gridColumns,
                    data: datasource
                }
                grid = new Tabulator(el, opts)
            }
        }
        let devicetypes
        let loadDeviceTypes = (callback) => {
            let langId = (lang.current) ? lang.current.langId : 'EN' 
            let url = '/api/devicetypes'
            let paramObj = {
                langId: langId
            }
            let fn = (r) => {
                let data = api.parse(r)
                devicetypes = data.records[langId]
                callback()
            }
            XHR.postJson(url, paramObj, fn)
        }
        let editRow = (e, cell) => {
            let data = cell.getRow().getData()
            loadDeviceTypes(() => {
                let editOpts = {
                    data: data,
                    lookup: {
                        devicetypes: devicetypes
                    },
                    isNew: false,
                    onClose: () => { 
                        dialog.hide()
                    },
                    onSave: () => {
                        dialog.hide()
                    }
                }
                dialog.show()
                if (editor) editor.setup(editOpts)
            })
        }
        let deleteRow = (e, cell) => {
            let data = cell.getRow().getData()
            console.log('delete:', data)
        }
        this.refresh = () => { updateContents() }
    </script>
</device-view>