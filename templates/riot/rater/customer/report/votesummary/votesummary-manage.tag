<votesummary-manage>
    <flip-screen ref="flipper">
        <yield to="viewer">
            <votesummary-search ref="viewer" class="view"></votesummary-search>
        </yield>
        <yield to="entry">
            <votesummary-result ref="entry" class="entry"></votesummary-result>
        </yield>
    </flip-screen>
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
        let defaultContent = {
            title: 'Vote Summary'
        }
        this.content = defaultContent;

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let flipper, view, entry
        let initCtrls = () => {
            flipper = self.refs['flipper']
            entry = (flipper) ? flipper.refs['entry'] : undefined
        }
        let freeCtrls = () => {
            entry = null
            flipper = null
        }
        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)
            addEvt(events.name.VoteSummarySearch, onShowSearch)
            addEvt(events.name.VoteSummaryResult, onShowResult)
        }
        let unbindEvents = () => {
            delEvt(events.name.VoteSummaryResult, onShowResult)
            delEvt(events.name.VoteSummarySearch, onShowSearch)
            delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onContentChanged = (e) => { updateContents() }
        let onLanguageChanged = (e) => { updateContents() }
        let onScreenChanged = (e) => { updateContents() }
        let onShowResult = (e) => {
            if (flipper) {
                flipper.toggle()
                let criteria = e.detail.data
                if (entry) entry.setup(criteria)
            }
            
        }
        let onShowSearch = (e) => {
            if (flipper) {
                flipper.toggle()
            }
        }
        let updateContents = () => {
            let scrId = screens.current.screenId
            let scrContent = (contents.current && contents.current.screens) ? contents.current.screens[scrId] : null
            self.content = scrContent ? scrContent : defaultContent
            self.update()
        }
    </script>
</votesummary-manage>