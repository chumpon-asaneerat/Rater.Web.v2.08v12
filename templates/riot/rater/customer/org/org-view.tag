<org-view>
    <!-- Need to change to org chart. -->
    <div ref="container" class="scrarea">
        <div class="canvasarea">
            <div ref="canvas"></div>
        </div>
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
            overflow: auto;
        }
        :scope>.scrarea>.canvasarea .orgchart {
            background-image: none; /* hide grid */
        }
        :scope>.scrarea>.canvasarea .orgchart .node .edge {
            display: none; /* disable collapse edges */
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

        let orgchart = null, datasource = {}
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
                //self.content.columns = partContent.columns
                // update canvas.
                loadDataSource()
            }
        }
        let buildTree = (dataset) => {
            let hashTable = Object.create(null)
            dataset.forEach(aData => hashTable[aData.orgId] = { ...aData, children : [] })
            let dataTree = []
            dataset.forEach(aData => {
                if (aData.parentId) {
                    hashTable[aData.parentId].children.push(hashTable[aData.orgId])
                }
                else {
                    dataTree.push(hashTable[aData.orgId])
                }
            })
            return (dataTree && dataTree.length > 0) ? dataTree[0] : {}
        }
        let nodeTemplate = (data) => {
            console.log(data)
            return `
                <div class="title">${data.OrgName}</div>
                <div class="content">${data.OrgName} - ${data.BranchName}</div>
            `;
        };
        let loadDataSource = () => {
            let langId = (lang.current) ? lang.current.langId : 'EN'
            let url = '/customers/api/orgs'
            let paramObj = {}
            paramObj.langId = langId
            let fn = (r) => {
                let data = api.parse(r)
                let src = (data.records && data.records[langId]) ? data.records[langId] : []
                // flatten
                datasource = buildTree(src)
                updateChart()
            }
            XHR.postJson(url, paramObj, fn)
        }
        let updateChart = () => {
            let el = self.refs['canvas']            
            if (el) {
                while (el.firstChild) {
                    el.firstChild.remove();
                }
                $(el).orgchart({
                    collapsed: false,
                    data: datasource,
                    nodeTitle: 'OrgName',
                    nodeContent: 'OrgName',
                    nodeID: 'orgId',
                    nodeTemplate: nodeTemplate
                })
            }
        }
    </script>
</org-view>