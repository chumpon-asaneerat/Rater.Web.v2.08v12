<branch-entry>
    <ninput ref="branchName" title="{ content.entry.branchName }" type="text" name="branchName"></ninput>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns
        let clone = nlib.utils.clone, equals = nlib.utils.equals

        let partId = 'branch-entry'
        this.content = {
            entry: { 
                branchName: 'Branch Name'
            }
        }

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let branchName;
        let initCtrls = () => {
            branchName = self.refs['branchName']
        }
        let freeCtrls = () => {
            branchName = null
        }
        let clearInputs = () => {
            branchName.clear()
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
            let propNames = [
                'entry.branchName'
            ]
            assigns(self.content, partContent, ...propNames)
        }

        let origObj
        let editObj
        let ctrlToObj = () => {
            if (editObj) {
                //console.log('ctrlToObj:', editObj)
                if (branchName) editObj.branchName = branchName.value()
            }
        }
        let objToCtrl = () => {
            if (editObj) {
                //console.log('objToCtrl:', editObj)
                if (branchName) branchName.value(editObj.branchName);
            }
        }
        this.setup = (item) => {
            clearInputs()
            origObj = clone(item)
            editObj = clone(item)
            //console.log('edit obj:', editObj)
            objToCtrl()
        }
        this.getItem = () => {
            ctrlToObj()
            //console.log('getItem:', editObj)
            let hasId = (editObj.branchId !== undefined && editObj.branchId != null)
            let isDirty = !hasId || !equals(origObj, editObj)
            //console.log(editObj)
            return (isDirty) ? editObj : null
        }
        this.refresh = () => { updateContents() }
    </script>
</branch-entry>