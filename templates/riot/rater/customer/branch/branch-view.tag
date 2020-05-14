<branch-view>
    <div ref="container" class="scrarea">
        <div ref="grid" class="gridarea"></div>
    </div>
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
            background: transparent;
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
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        let partId = 'branch-view'
        this.content = {
            columns: [
                { title: 'Branch Name', field: 'branchName', resizable: false }
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
        let initCtrls = () => {}
        let freeCtrls = () => {
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
            let url = '/customers/api/branchs'
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
            return "<button><span class='fas fa-edit'></span></button>";
        };
        let updateGrid = () => {
            let el = self.refs['grid']
            if (el) {
                let gridColumns = []
                gridColumns.push({ formatter: editIcon, hozAlign: "center", width: 56, 
                    resizable: false, frozen: true, headerSort: false,
                    cellClick: editRow
                })
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
        let editRow = (e, cell) => {}
        this.refresh = () => { updateContents() }
    </script>
</branch-view>