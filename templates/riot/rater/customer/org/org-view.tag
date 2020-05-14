<org-view>
    <!-- Need to change to org chart. -->
    <div ref="container" class="scrarea">
        <div ref="canvas" class="canvasarea"></div>
    </div>
    <style>
        :scope {
            position: relative;
            margin: 0;
            padding: 2px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 20px 1fr 20px;
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
                'canvasarea';
            margin: 0 auto;
            padding: 0;
            width: 100%;
            max-width: 800px;
            height: 100%;
            overflow: hidden;
        }
        :scope>.scrarea>.canvasarea {
            grid-area: canvasarea;
            margin: 0 auto;
            padding: 0;
            height: 100%;
            width: 100%;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        let partId = 'org-view'

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let orgchart = null, datasource = []
        let initCtrls = () => {}
        let freeCtrls = () => {
            orgchart = null
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
                // update canvas.
                loadDataSource()
            }
        }
        let loadDataSource = () => {
            let langId = (lang.current) ? lang.current.langId : 'EN'
            let url = '/customers/api/orgs'
            let paramObj = {}
            paramObj.langId = langId
            let fn = (r) => {
                let data = api.parse(r)
                datasource = (data.records && data.records[langId]) ? data.records[langId] : []
                updateChart()
            }
            XHR.postJson(url, paramObj, fn)
        }
        let updateChart = () => {
            let el = self.refs['canvas']
            if (el) {
                console.log('el:', el)
                console.log('datasource:', datasource)
            }
        }
    </script>
</org-view>