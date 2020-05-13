<branch-view>
    <div ref="container" class="scrarea">
        <div class="gridarea">
            <div ref="grid" class="gridwrapper"></div>
        </div>
    </div>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0;
            padding: 0;
            overflow: hidden;
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

        let initCtrls = () => { }
        let freeCtrls = () => { }
        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            //addEvt(events.name.ScreenChanged, onScreenChanged)
        }
        let unbindEvents = () => {
            //delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onLanguageChanged = () => { updateContents() }
        let onScreenChanged = () => { updateContents() }
        let onContentChanged = () => { updateContents() }

        let reloadData = () => {}
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)

            // load columns
            self.content.columns = partContent.columns
            // update grid.
        }

        this.setup = () => {}
        this.refresh = () => {}
    </script>
</branch-view>