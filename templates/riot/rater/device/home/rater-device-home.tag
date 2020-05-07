<rater-device-home>
    <h3>{ content.title }</h3>
    <a href="javascript:;"><span>{ content.labels.register }</span></a>
    <a href="javascript:;"><span>{ content.labels.setupOrg }</span></a>
    <a href="javascript:;"><span>{ content.labels.setupUser }</span></a>
    <a href="javascript:;"><span>{ content.labels.question }</span></a>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0 auto;
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

        let partId = 'rater-device-home'
        this.content = {
            title: 'Rater Device Main Menu',
            labels: {
                register: 'Register device',
                setupOrg: 'Change Organization',
                setupUser: 'Sign In',
                question: 'Goto Question Screen'
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

        let initCtrls = () => {}
        let freeCtrls = () => {}
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

        let updateContents = () => {
            //let partsContent = contents.getParts()
            //console.log('all parts:', partsContent)
            let partContent = contents.getPart(partId)
            let propNames = [
                'labels.register',
                'labels.setupOrg',
                'labels.setupUser',
                'labels.question'
            ]
            assigns(self.content, partContent, ...propNames)
        }
        let onScreenChanged = () => {
            updateContents()
        }
        let onContentChanged = () => {
            updateContents()
        }
        let onLanguageChanged = () => {
            updateContents()
        }

        this.refresh = () => {}
    </script>
</rater-device-home>