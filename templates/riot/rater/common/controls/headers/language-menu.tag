<language-menu>
    <div class="menu">
        <a ref="flags" class="flag-combo" href="javascript:;">
            <span class="flag-css flag-icon flag-icon-{ lang.current.flagId.toLowerCase() }" ref="css-icon"></span>
            <div class="flag-text">&nbsp;{ lang.langId }&nbsp;</div>
            <virtual if={ isMultiple() }>
                <span class="drop-synbol fas fa-caret-down"></span>
            </virtual>
        </a>
    </div>
    <div ref="dropItems" class="language-dropbox">
        <div each={ item in lang.languages }>
            <a class="flag-item { (lang.langId === item.langId) ? 'selected' : '' }" href="javascript:;" onclick="{ selectItem }">
                &nbsp;
                <span class="flag-css flag-icon flag-icon-{ item.flagId.toLowerCase() }" ref="css-icon"></span>
                &nbsp;&nbsp;
                <div class="flag-text">{ item.Description }</div>
                &nbsp;&nbsp;&nbsp;
            </a>                
        </div>
    </div>
    <style>
        :scope {
            display: inline-block;
            margin: 0 auto;
            padding: 0, 2px;
            user-select: none;
        }
        .menu {
            display: inline-block;
            margin: 0 auto;
            padding: 0;
        }
        a {
            display: inline-block;
            margin: 0 auto;
            color: whitesmoke;            
        }
        a:link, a:visited { text-decoration: none; }
        a:hover, a:active {
            color: yellow;
            text-decoration: none;
        }
        .flag-combo {
            display: inline-block;
            margin: 0 auto;
        }
        .flag-combo .flag-css {
            display: inline-block;
            margin: 0 auto;
            padding-top: 1px;
        }
        .flag-combo .flag-text {
            display: inline-block;
            margin: 0 auto;
        }
        .flag-combo .drop-symbol {
            display: inline-block;
            margin: 0 auto;
        }
        .flag-item {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            padding: 0;
            padding-left: 2px;
            height: 50px;
        }
        .flag-item:hover {
            color: yellow;
            background:linear-gradient(to bottom, #0c5a24 5%, #35750a 100%);
            background-color:#77a809;
            cursor: pointer;
        }
        .flag-item.selected {
            background-color: darkorange;
        }
        .flag-item .flag-css {
            display: inline-block;
            margin: 0px auto;
            padding-top: 1px;
            width: 25px;
        }
        .flag-item .flag-text {
            display: inline-block;
            margin: 0 auto;
            min-width: 80px;
            max-width: 120px;
        }
        .language-dropbox {
            display: inline-block;
            position: fixed;
            margin: 0 auto;
            padding: 1px;
            top: 45px;
            right: 5px;
            background-color: #333;
            color:whitesmoke;
            max-height: calc(100vh - 50px - 20px);
            overflow: hidden;
            overflow-y: auto;
            display: none;
        }
        .language-dropbox.show {
            display: inline-block;
            z-index: 99999;
        }
    </style>
    <script>
        let self = this;
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        });
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        });

        let flags, dropItems
        let initCtrls = () => {
            flags = self.refs['flags']
            dropItems = self.refs['dropItems']
        }
        let freeCtrls = () => {
            dropItems = null
            flags = null
        }

        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            flags.addEventListener('click', toggle);
            window.addEventListener('click', checkClickPosition);
        }
        let unbindEvents = () => {
            window.removeEventListener('click', checkClickPosition);
            flags.removeEventListener('click', toggle);
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }

        let onLanguageChanged = (e) => {
            self.update()
        }
        let toggle = () => {
            dropItems.classList.toggle('show')
            self.update()
        }
        let isInClassList = (elem, classList) => {
            let len = classList.length
            let found = false
            for (let i = 0; i < len; i++) {
                if (elem.matches(classList[i])) {
                    found = true
                    break
                }
            }
            return found
        }
        let checkClickPosition = (e) => {
            // Close the dropdown menu if the user clicks outside of it
            let classList = ['.flag-combo', '.flag-css', '.flag-text', '.drop-synbol']
            let match = isInClassList(e.target, classList)
            if (!match) {
                if (dropItems.classList.contains('show')) {
                    toggle()
                }
            }
        }
        this.isMultiple = () => { 
            return lang && lang.languages && lang.languages.length > 1
        }
        this.selectItem = (e) => {
            toggle(); // toggle off
            let selLang = e.item.item
            lang.change(selLang.langId)
            e.preventDefault()
            e.stopPropagation()
        }

    </script>
</language-menu>