<branch-editor>
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
            <tabpages class="pages">
                <tabpage name="default">
                    <div class="tab-body-container">
                        <branch-entry ref="EN" langId=""></branch-entry>
                    </div>
                </tabpage>
                <tabpage name="miltilang">
                    <div class="tab-body-container">
                        <virtual if={ lang.languages }>
                            <virtual each={ item in lang.languages }>
                                <virtual if={ item.langId !== 'EN' }>
                                    <div class="panel-header" langId="{ item.langId }">
                                        &nbsp;&nbsp;
                                        <span class="flag-css flag-icon flag-icon-{ item.flagId.toLowerCase() }"></span>
                                        &nbsp;{ item.Description }&nbsp;
                                    </div>
                                    <div class="panel-body" langId="{ item.langId }">
                                        <branch-entry ref="{ item.langId }" langId="{ item.langId }"></branch-entry>
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
            position: relative;
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
            display: grid;
            grid-template-columns: 1fr auto 5px;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'tabs tool .';
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.entry .tabs {
            grid-area: tabs;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.entry .pages .tab-body-container {
            margin: 0 auto;
            padding: 5px;
            width: 100%;
            height: 100%;
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
            padding: 5px;
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
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns
        let clone = nlib.utils.clone, equals = nlib.utils.equals

        let partId = 'branch-editor'
        this.content = {
            entry: { 
                tabDefault: 'Default',
                tabMultiLang: 'Languages'
            }
        }
        opts.content = this.content; // update 2019-12-19

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
            addEvt(events.name.ContentChanged, onContentChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ContentChanged, onContentChanged)
        }
        let onContentChanged = (e) => { updateContents() }

        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            let propNames = [
                'entry.tabDefault',
                'entry.tabMultiLang'
            ]
            assigns(self.content, partContent, ...propNames)
            opts.content = this.content; // update 2019-12-19
        }
        // update 2019-12-19
        findCtrl = (langId) => {
            let ctrl;
            let tabpages = self.tags['tabcontrol'].tags['tabpages'].tags['tabpage'];
            for (let i = 0; i < tabpages.length; i++) {
                let tp = tabpages[i];
                ctrl = tp.refs[langId];
                if (ctrl) break;
            }
            return ctrl;
        }
        let editorOptions
        let editItem
        let isNew
        let loadItem = () => {
            editItem = null
            isNew = false
            if (editorOptions && editorOptions.data) {
                isNew = editorOptions.isNew
                let url = '/customers/api/branchs/search'
                let paramObj = {
                    branchId: editorOptions.data.branchId
                }
                paramObj.langId = null
                let fn = (r) => {
                    let data = api.parse(r)
                    editItem = data.records
                    bindControls()
                }
                XHR.postJson(url, paramObj, fn)
            }
        }
        let ctrls = []
        let bindControls = () => {
            ctrls = []
            isNew = false
            lang.languages.forEach(lg => {
                let ctrl = findCtrl(lg.langId) // update 2019-12-19
                let original = (isNew) ? clone(editItem) : editItem[lg.langId][0]
                if (ctrl) {
                    let obj = {
                        langId: lg.langId,
                        entry: ctrl,
                        scrObj: original
                    }
                    ctrl.setup(original);
                    ctrls.push(obj)
                }
            })
        }
        let saveItems = (items) => {
            let self = this;
            let url = '/customers/api/branchs/save'
            //console.log('save:', items)
            let paramObj = {
                items: items
            };
            let fn = (r) => {
                let results = []
                for (let i = 0; i < r.result.length; i++) {
                    let data = {}
                    data.records = r.result[i].data
                    data.out = r.result[i].out
                    data.errors = r.result[i].errors
                    results.push(data)
                }
                // close after save
                if (editorOptions && editorOptions.onSave) editorOptions.onSave()
            }
            XHR.postJson(url, paramObj, fn)
        }
        this.save = (e) => {
            let item;
            let items = []
            ctrls.forEach(oRef => {
                item = (oRef.entry) ? oRef.entry.getItem() : null
                if (item) {
                    item.langId = oRef.langId
                    items.push(item)
                }
            })
            saveItems(items)
        }
        this.cancel = (e) => {
            // close without save
            if (editorOptions && editorOptions.onClose) editorOptions.onClose()
        }
        this.setup = (editOpts) => {
            editorOptions = editOpts
            loadItem()
        }
        this.refresh = () => {}
    </script>
</branch-editor>