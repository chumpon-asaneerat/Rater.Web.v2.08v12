<branch-view>
    <div ref="container" class="scrarea">
        <div class="gridarea">
            <div ref="grid" class="gridarea"></div>
        </div>
    </div>
    <style>
        :scope {
            position: relative;
            margin: 0;
            padding: 0;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 20px 1fr 20px;
            grid-template-areas: 
                '.'
                'scrarea'
                '.'
        }
        :scope>.scrarea {
            grid-area: scrarea;
            display: grid;
            grid-template-columns: 5px auto 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                '. toolarea gridarea';
            margin: 0 auto;
            padding: 0;
            margin-top: 3px;
            width: 100%;
            max-width: 800px;
            height: 100%;
        }
        :scope>.scrarea>.toolarea {
            grid-area: toolarea;
            margin: 0 auto;
            margin-right: 5px;
            padding: 0;
            height: 100%;
            overflow: hidden;
            background-color: transparent;
            color: whitesmoke;
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
        let assigns = nlib.utils.assigns

        let partId = 'branch-view'
        this.content = {
            columns: [
                { title: 'Branch Name', 'field': 'branchName', resizable: false }
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

        let grid;
        let initCtrls = () => {
            let el = self.refs['grid']
            if (el) {
                console.log('el exists.')
                let opts = {
                    height: "100%",
                    layout: 'fitColumns',
                    selectable: 1,
                    index: self.content.columns[0].field,
                    data: []
                }
                grid = new Tabulator(el, opts)
                // apply or overwrite existing columns with new columns definition array
                grid.setColumns(self.content.columns)
                console.log(self.content.columns)
            }
        }
        let freeCtrls = () => {
            grid = null
        }
        let bindEvents = () => {
            //addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            //addEvt(events.name.ScreenChanged, onScreenChanged)
        }
        let unbindEvents = () => {
            //delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            //delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onLanguageChanged = () => { updateContents() }
        let onScreenChanged = () => { updateContents() }
        let onContentChanged = () => { updateContents() }

        let datasource;
        let currentLangId = () => { return (lang.current) ? lang.current.langId : 'EN' } 
        let loadDataSource = () => {
            let url = '/customers/api/branchs'
            let paramObj = {}
            paramObj.langId = currentLangId()
            let fn = (r) => {
                let data = api.parse(r)
                datasource = data.records
                updateDatasource()
            }
            XHR.postJson(url, paramObj, fn)
        }
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            // load columns
            if (partContent) {
                self.content.columns = partContent.columns
                // apply or overwrite existing columns with new columns definition array
                if (grid) grid.setColumns(self.content.columns)
            }
            // update grid.
            loadDataSource()
            updateDatasource()
        }

        let updateDatasource = () => {
            console.log('update datasource called')
            console.log('grid:', grid)
            console.log('datasource:', datasource)
            if (grid && datasource) grid.setData(datasource[currentLangId()])
        }

        this.setup = () => {}
        this.refresh = () => {}
    </script>
</branch-view>