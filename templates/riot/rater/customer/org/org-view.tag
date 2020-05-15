<org-view>
    <!-- Need to change to org chart. -->
    <div ref="container" class="scrarea">
        <div class="canvasarea">
            <div ref="canvas"></div>
        </div>
    </div>
    <ndialog ref="dialog">
        <org-editor ref="editor"></org-editor>
    </ndialog>
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
            box-shadow: var(--default-box-shadow);
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
        :scope>.scrarea>.canvasarea .orgchart .node {
            padding: 3px;
            width: auto;
            min-width: 150px;
        }
        :scope>.scrarea>.canvasarea .orgchart .node .content {
            padding: 3px;
            height: auto; /* override orgchart node height. */
            min-height: 2.2rem;
            font-weight: bold;
        }
        :scope>.scrarea>.canvasarea .orgchart .node .add-node,
        :scope>.scrarea>.canvasarea .orgchart .node .edit-node,
        :scope>.scrarea>.canvasarea .orgchart .node .delete-node {
            color: black;
            cursor: pointer;
            margin: 0;
            padding: 2px;
            width: 25px;
            height: 20px;
        }
        :scope>.scrarea>.canvasarea .orgchart .node .add-node:hover,
        :scope>.scrarea>.canvasarea .orgchart .node .edit-node:hover,
        :scope>.scrarea>.canvasarea .orgchart .node .delete-node:hover {
            color: cornflowerblue;
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
        let dialog, editor
        let initCtrls = () => {
            dialog = self.refs['dialog']
            editor = (dialog) ? dialog.refs['editor'] : null
        }
        let freeCtrls = () => {
            dialog = null
            editor = null
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
            //console.log(data)
            return `
                <div class="title">${data.OrgName}</div>
                <div class="content">
                        <span>${data.OrgName}</span>
                        <br/>
                        <span>(${data.BranchName})</span>
                </div>
                <div style="display: block; position: relative; margin: 0 auto; padding: 2px;">
                    <span class='add-node fas fa-plus'></span>&nbsp;
                    <span class='edit-node fas fa-edit'></span>&nbsp;
                    <span class='delete-node fas fa-trash-alt'></span>
                </div>
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
                // array to tree
                datasource = buildTree(src)
                updateChart()
            }
            XHR.postJson(url, paramObj, fn)
        }
        let updateChart = () => {
            let el = self.refs['canvas']
            selectedItem = null  
            if (el) {
                while (el.firstChild) {
                    el.firstChild.remove();
                }
                let oc = $(el).orgchart({
                    collapsed: false,
                    data: datasource,
                    //pan: true,
                    //zoom: true,
                    nodeTitle: 'OrgName',
                    nodeContent: 'OrgName',
                    nodeID: 'orgId',
                    nodeTemplate: nodeTemplate,
                    'createNode': ($node, data) => {
                        let $add = $node.find('.add-node')
                        let $edit = $node.find('.edit-node')
                        let $del = $node.find('.delete-node')
                        $add.on('mousedown', (evt) => addNode(data))
                        $edit.on('mousedown', (evt) => editNode(data))
                        $del.on('mousedown', (evt) => deleteNode(data))
                    }
                })
            }
        }

        let addNode = (data) => {
            console.log('add click:', data)
        }
        let editNode = (data) => {
            console.log('edit click:', data)
        }
        let deleteNode = (data) => {
            console.log('delete click:', data)
        }
    </script>
</org-view>