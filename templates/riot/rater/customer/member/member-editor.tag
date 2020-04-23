<member-editor>
    <div class="entry">
        <tabcontrol class="tabs" content={ opts.content }>
            <tabheaders content={ opts.content }>
                <tabheader for="default" content={ opts.content }>
                    <span class="fas fa-cog"></span>
                    { opts.content.entry.tabDefault }
                </tabheader>
                <tabheader for="miltilang" content={ opts.content }>
                    <span class="fas fa-globe-americas"></span>
                    { opts.content.entry.tabMultiLang }
                </tabheader>
            </tabheaders>
            <tabpages>
                <tabpage name="default">
                    <div class="scrollable">
                        <member-entry ref="EN" langId=""></member-entry>
                    </div>
                </tabpage>
                <tabpage name="miltilang">
                    <div class="scrollable">
                        <virtual if={ lang.languages }>
                            <virtual each={ item in lang.languages }>
                                <virtual if={ item.langId !=='EN' }>
                                    <div class="panel-header" langId="{ item.langId }">
                                        &nbsp;&nbsp;
                                        <span class="flag-css flag-icon flag-icon-{ item.flagId.toLowerCase() }"></span>
                                        &nbsp;{ item.Description }&nbsp;
                                    </div>
                                    <div class="panel-body" langId="{ item.langId }">
                                        <member-entry ref="{ item.langId }" langId="{ item.langId }"></member-entry>
                                    </div>
                                </virtual>
                            </virtual>
                        </virtual>
                    </div>
                </tabpage>
            </tabpages>
        </tabcontrol>
        <div class="tool">
            <button class="float-button save" onclick="{ save }"><span class="fas fa-save"></span></button>
            <button class="float-button cancel" onclick="{ cancel }"><span class="fas fa-times"></span></button>
        </div>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
            width: 100%;
            max-width: 800px;
            height: 100%;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas:
                'entry';
            background-color: white;
            overflow: hidden;
        }
        :scope>.entry {
            grid-area: entry;
            position: relative;
            display: grid;
            grid-template-columns: 1fr auto 5px;
            grid-template-rows: 1fr;
            grid-template-areas:
                'tabs tool .';
            margin: 0 auto;
            padding: 0;
            padding-top: 20px;
            padding-bottom: 20px;
            width: 100%;
            height: 100%;
            overflow: auto;
        }
        :scope>.entry .tabs {
            grid-area: tabs;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope .scrollable {
            position: absolute;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
        }
        :scope>.entry .tool {
            grid-area: tool;
            display: grid;
            grid-template-columns: 1fr auto;
            grid-template-rows: auto 1fr auto;
            grid-template-areas:
                '. .'
                'btn-cancel .'
                'btn-save .';
            margin: 0 auto;
            margin-left: 3px;
            padding: 0;
            width: 100%;
            height: 100%;
            /* background-color: sandybrown; */
            overflow: hidden;
        }
        :scope>.entry .tool .float-button {
            margin: 0 auto;
            padding: 0;
            border: none;
            outline: none;
            border-radius: 50%;
            height: 40px;
            width: 40px;
            color: whitesmoke;
            background: silver;
            cursor: pointer;
        }
        :scope>.entry .tool .float-button:hover {
            color: whitesmoke;
            background: forestgreen;
        }
        :scope>.entry .tool .float-button.save {
            grid-area: btn-save;
        }
        :scope>.entry .tool .float-button.cancel {
            grid-area: btn-cancel;
        }
        :scope .panel-header {
            margin: 0 auto;
            padding: 0;
            padding-top: 3px;
            width: 100%;
            height: 30px;
            color: white;
            background: cornflowerblue;
            border-radius: 5px 5px 0 0;
        }
        :scope .panel-body {
            margin: 0 auto;
            margin-bottom: 5px;
            padding: 2px;
            width: 100%;
            border: 1px solid cornflowerblue;
        }
    </style>
    <script>
        let self = this;
        let screenId = 'member-entry'
        let defaultContent = {
            entry: { 
                tabDefault: 'Default',
                tabMultiLang: 'Languages'
            }
        }
        this.content = defaultContent
        opts.content = this.content

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
        })

        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }

        let onContentChanged = (e) => { updatecontent(); }
        let onLanguageChanged = (e) => { updatecontent(); }
        let onScreenChanged = (e) => { updatecontent(); }
        let updatecontent = () => {
            if (screens.is(screenId)) {
                let scrContent = contents.getScreenContent()
                self.content = scrContent ? scrContent : defaultContent;
                opts.content = self.content;
                self.update();
            }
        }
    </script>
</member-editor>