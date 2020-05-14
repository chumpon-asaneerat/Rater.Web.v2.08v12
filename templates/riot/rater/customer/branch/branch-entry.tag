<branch-entry>
    <ninput ref="branchName" title="{ content.entry.branchName }" type="text" name="branchName"></ninput>
    <div class="padtop"></div>
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
        :scope .padtop {
            position: relative;
            display: block;
            margin: 0 auto;
            width: 100%;
            min-height: 10px;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns

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

        this.setup = (item) => {
            // set item (1 language)
        }
        this.refresh = () => { updateContents() }
    </script>
</branch-entry>