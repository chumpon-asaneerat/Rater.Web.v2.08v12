<rater-device-home>
    <div class="container-area">
        <div class="title"><span>{ content.title }</span></div>
        <div class="menus">
            <div class="menu">
                <a href="javascript:;"><span>{ content.labels.register }</span></a>
            </div>
            <div class="menu">
                <a href="javascript:;"><span>{ content.labels.setupOrg }</span></a>
            </div>
            <div class="menu">
                <a href="javascript:;"><span>{ content.labels.setupUser }</span></a>
            </div>
            <div class="menu">
                <a href="javascript:;"><span>{ content.labels.question }</span></a>
            </div>
        </div>
    </div>
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
        :scope>.container-area {
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: auto 1fr;
            grid-template-areas: 
                'title-area'
                'menus-area';
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.container-area>.title {
            grid-area: title-area;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto;
            padding: 5px;
            width: 100%;
            height: 100%;
        }
        :scope>.container-area>.menus {
            grid-area: menus-area;
            position: relative;
            display: grid;
            /* grid-template-rows: repeat(2, 1fr); */
            grid-template-columns: repeat(2, 1fr);
            margin: 0 auto;
            padding: 5px;
            width: 100%;
            height: 100%;
        }
        :scope>.container-area>.menus .menu {
            /* grid-area: menu-area; */
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 5px;
            width: 100%;
            height: 100%;
        }
        :scope>.container-area>.menus .menu>a {
            position: relative;
            display: flex;
            align-items: center;
            justify-items: stretch;
            justify-content: center;
            font-size: 1.2rem;
            margin: 0;
            padding: 5px;
            width: 100%;
            height: 100%;
            color: whitesmoke;
            background-color: forestgreen;
            text-decoration: none;
        }
        :scope>.container-area>.menus .menu>a:hover {
            color: whitesmoke;
            background-color: cornflowerblue;
        }
        :scope>.container-area>.menus .menu>a>span {
            position: relative;
            display: inline-block;
            margin: 0;
            padding: 0;
            width: auto;
            height: auto;
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
            let partContent = contents.getPart(partId)
            let propNames = [
                'labels.register',
                'labels.setupOrg',
                'labels.setupUser',
                'labels.question'
            ]
            assigns(self.content, partContent, ...propNames)
        }
        let onLanguageChanged = () => { updateContents() }
        let onScreenChanged = () => { updateContents() }
        let onContentChanged = () => { updateContents() }

        this.setup = () => {}
        this.refresh = () => {}
    </script>
</rater-device-home>