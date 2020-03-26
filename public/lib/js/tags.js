riot.tag2('ninput', '<input ref="input" type="{opts.type}" name="{opts.name}" riot-value="{opts.value}" required="" autocomplete="off"> <div ref="clear" class="clear">x</div> <label>{opts.title}</label>', 'ninput,[data-is="ninput"]{ margin: 0; margin-top: 5px; padding: 10px; font-size: 14px; display: inline-block; position: relative; height: auto; width: 100%; background: transparent; box-shadow: 0 5px 10px solid rgba(0, 0, 0, .2); } ninput input,[data-is="ninput"] input{ display: inline-block; padding: 20px 0 10px 0; margin-bottom: 0px; width: calc(100% - 25px); background-color: whitesmoke; box-sizing: border-box; box-shadow: none; outline: none; border: none; font-size: 14px; box-shadow: 0 0 0px 1000px white inset; border-bottom: 2px solid #999; } ninput .clear,[data-is="ninput"] .clear{ display: inline-block; margin: 0; padding: 0px 6px; font-size: 12px; font-weight: bold; width: 21px; height: 21px; color: white; cursor: pointer; user-select: none; border: 1px solid red; border-radius: 50%; background: rgba(255, 100, 100, .75); } ninput .clear:hover,[data-is="ninput"] .clear:hover{ color: yellow; background: rgba(255, 0, 0, .8); } ninput input:-webkit-autofill,[data-is="ninput"] input:-webkit-autofill,ninput input:-webkit-autofill:hover,[data-is="ninput"] input:-webkit-autofill:hover,ninput input:-webkit-autofill:focus,[data-is="ninput"] input:-webkit-autofill:focus{ font-size: 14px; transition: background-color 5000s ease-in-out 0s; } ninput label,[data-is="ninput"] label{ position: absolute; top: 30px; left: 14px; color: #555; transition: .2s; pointer-events: none; } ninput input:focus ~ label,[data-is="ninput"] input:focus ~ label{ top: 5px; left: 10px; color: #f7497d; font-weight: bold; } ninput input:-webkit-autofill ~ label,[data-is="ninput"] input:-webkit-autofill ~ label,ninput input:valid ~ label,[data-is="ninput"] input:valid ~ label{ top: 5px; left: 10px; color: cornflowerblue; font-weight: bold; } ninput input:focus,[data-is="ninput"] input:focus{ border-bottom: 2px solid #f7497d; } ninput input:valid,[data-is="ninput"] input:valid{ border-bottom: 2px solid cornflowerblue; }', '', function(opts) {


        let self = this;

        let input, clear;

        let initCtrls = () => {
            input = self.refs['input'];
            clear = self.refs['clear'];
            checkOnBlur();
        }
        let freeCtrls = () => {
            flipper = null;
        }
        let clearInputs = () => {
            input = null;
            clear = null;
        }

        let bindEvents = () => {
            input.addEventListener('focus', checkOnFocus);
            input.addEventListener('blur', checkOnBlur);
            clear.addEventListener('click', onClear);
        }
        let unbindEvents = () => {
            clear.removeEventListener('click', onClear);
            input.removeEventListener('blur', checkOnBlur);
            input.removeEventListener('focus', checkOnFocus);
        }

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            clearInputs();
        });

        let oType;
        let checkOnFocus = () => {
            if (input) {

                if (!oType) {
                    oType = input.type;
                    if (self.opts.type === 'date') {

                        input.value = moment().format('YYYY-MM-DD');
                    }
                }
                if (oType === 'date' && self.opts.type === 'date') {
                    if (input.value === '') {
                        input.type = 'date'
                    }
                }
            }
        }
        let checkOnBlur = () => {
            if (input) {

                if (!oType) {
                    oType = input.type;
                    if (self.opts.type === 'date') {

                        input.value = moment().format('YYYY-MM-DD');
                    }
                }
                if (oType === 'date' && self.opts.type === 'date') {
                    if (input.value === '') {
                        input.type = 'text'
                    }
                }
            }
        }
        let onClear = () => {
            if (input) input.value = '';
            checkOnBlur();
        }

        this.clear = () => { if (input) input.value = ''; }
        this.focus = () => { if (input) input.focus(); }
        this.value = (text) => {
            let ret;
            if (input) {
                if (text !== undefined && text !== null) {
                    input.value = text;
                    checkOnBlur();
                }
                else {
                    ret = input.value;
                }
            }
            return ret;
        }

});
riot.tag2('nselect', '<select ref="input"> <option each="{item in items}" riot-value="{item.value}">{item.text}</option> </select> <div ref="clear" class="clear">x</div> <label>{opts.title}</label>', 'nselect,[data-is="nselect"]{ margin: 0; margin-top: 5px; padding: 10px; font-size: 14px; display: inline-block; position: relative; height: auto; width: 100%; background: transparent; box-shadow: 0 5px 10px solid rgba(0, 0, 0, .2); } nselect select,[data-is="nselect"] select{ display: inline-block; padding: 20px 0 10px 0; margin-bottom: 0px; width: calc(100% - 25px); background-color: whitesmoke; box-sizing: border-box; box-shadow: none; outline: none; border: none; font-size: 14px; box-shadow: 0 0 0px 1000px white inset; border-bottom: 2px solid #999; -webkit-appearance: none; -moz-appearance: none; background-image: url("data:image/svg+xml;utf8,<svg fill=\'black\' height=\'24\' viewBox=\'0 0 24 24\' width=\'24\' xmlns=\'http://www.w3.org/2000/svg\'><path d=\'M7 10l5 5 5-5z\'/><path d=\'M0 0h24v24H0z\' fill=\'none\'/></svg>"); background-repeat: no-repeat; background-position-x: 100%; background-position-y: 20px; border-radius: 2px; } nselect .clear,[data-is="nselect"] .clear{ display: inline-block; margin: 0; padding: 0px 6px; font-size: 12px; font-weight: bold; width: 21px; height: 21px; color: white; cursor: pointer; user-select: none; border: 1px solid red; border-radius: 50%; background: rgba(255, 100, 100, .75); } nselect .clear:hover,[data-is="nselect"] .clear:hover{ color: yellow; background: rgba(255, 0, 0, .8); } nselect select:-webkit-autofill,[data-is="nselect"] select:-webkit-autofill,nselect select:-webkit-autofill:hover,[data-is="nselect"] select:-webkit-autofill:hover,nselect select:-webkit-autofill:focus,[data-is="nselect"] select:-webkit-autofill:focus{ font-size: 14px; transition: background-color 5000s ease-in-out 0s; } nselect label,[data-is="nselect"] label{ position: absolute; top: 30px; left: 14px; color: #555; transition: .2s; pointer-events: none; } nselect select:focus ~ label,[data-is="nselect"] select:focus ~ label{ top: 5px; left: 10px; color: #f7497d; font-weight: bold; } nselect select:-webkit-autofill ~ label,[data-is="nselect"] select:-webkit-autofill ~ label,nselect select:valid ~ label,[data-is="nselect"] select:valid ~ label{ top: 5px; left: 10px; color: cornflowerblue; font-weight: bold; } nselect select:focus,[data-is="nselect"] select:focus{ border-bottom: 2px solid #f7497d; } nselect select:valid,[data-is="nselect"] select:valid{ border-bottom: 2px solid cornflowerblue; }', '', function(opts) {


        let self = this;
        let fldmap = { valueField:'code', textField:'name' }
        let defaultItem = {
            value: '',
            text: '-',
            source: null
        };
        this.items = [];
        this.items.push(defaultItem);

        let input, clear;

        let initCtrls = () => {
            input = self.refs['input'];
            clear = self.refs['clear'];
            disableFirstOption();
        }
        let freeCtrls = () => {
            input = null;
            clear = null;
        }
        let clearInputs = () => {
            if (input) {
                input.selectedIndex = 0;
            }
        }
        let disableFirstOption = () => {
            if (input && input.options[0]) {
                let opt = input.options[0];
                opt.setAttribute('disable', '')
                opt.setAttribute('selected', '')
                opt.style.display = 'none';
            }
        }

        let bindEvents = () => {
            input.addEventListener('change', onSelection);
            clear.addEventListener('click', onClear);
        }
        let unbindEvents = () => {
            clear.removeEventListener('click', onClear);
            input.removeEventListener('change', onSelection);
        }

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            clearInputs();
        });

        let onChangeCallback;
        let onClear = () => {
            clearInputs();
        }
        let onSelection = (e) => {
            if (input) {
                let idx = input.selectedIndex
                let val = input.options[input.selectedIndex].value;

                if (onChangeCallback) onChangeCallback();
            }
        }

        this.clear = () => { clearInputs(); }
        this.focus = () => { if (input) input.focus(); }

        let hasValue = (val) => {
            return (val !== undefined && val !== null);
        }
        let getSelectedIndexByValue = (val) => {
            let sVal = val.toString();
            let opt, idx = 0;
            for (let i = 0; i < input.options.length; i++) {
                opt = input.options[i];
                if (opt.value.toString() === sVal) {

                    idx = i
                    break;
                }
            }
            return idx;
        }
        let getSelectedValue = () => {
            let idx = input.selectedIndex
            let ret = (idx > 0) ? input.options[input.selectedIndex].value : null;
            return ret;
        }
        this.value = (val) => {
            let ret;
            if (input) {
                if (hasValue(val)) {
                    input.selectedIndex = getSelectedIndexByValue(val);
                }
                else {
                    ret = getSelectedValue();
                }
            }
            return ret;
        }
        this.setup = (values, fldMap, callback) => {
            fldmap = fldMap;
            onChangeCallback = callback;
            self.items = [];
            self.items.push(defaultItem);
            values.forEach(val => {
                let item = {
                    value: val[fldmap.valueField],
                    text: val[fldmap.textField],
                    source: val
                }
                self.items.push(item);
            })
            disableFirstOption();
            self.update();
        }

});

riot.tag2('ndialog', '<div class="modal-content"> <span ref="closeBtn" class="close">&times;</span> <p>Some text in the Modal..</p> </div>', 'ndialog,[data-is="ndialog"]{ display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgb(0,0,0); background-color: rgba(0,0,0,0.4); } ndialog .modal-content,[data-is="ndialog"] .modal-content{ background-color: #fefefe; margin: 15% auto; padding: 20px; border: 1px solid #888; width: 80%; } ndialog .close,[data-is="ndialog"] .close{ color: #aaa; float: right; font-size: 28px; font-weight: bold; } ndialog .close:hover,[data-is="ndialog"] .close:hover,ndialog .close:focus,[data-is="ndialog"] .close:focus{ color: black; text-decoration: none; cursor: pointer; }', '', function(opts) {


        let self = this;

        let closeBtn;
        let initCtrls = () => {
            closeBtn = self.refs['closeBtn']
        }
        let freeCtrls = () => {
            closeBtn = null;
        }

        let addEvt = (evtName, handle) => { document.addEventListener(evtName, handle) }
        let delEvt = (evtName, handle) => { document.removeEventListener(evtName, handle) }

        let bindEvents = () => {

            window.addEventListener('click', windowClick)
            closeBtn.addEventListener('click', closeClick)
        }
        let unbindEvents = () => {
            closeBtn.removeEventListener('click', closeClick)
            window.removeEventListener('click', windowClick)

        }

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            freeCtrls();
        });

        let windowClick = (evt) => {

            if (evt.target === self.root) {
                console.log('target:', evt.target)
                self.hide()
            }
        }
        let closeClick = (evt) => {
            self.hide()
        }
        this.show = () => {
            self.root.style.display = "block";
        }
        this.hide = () => {
            self.root.style.display = "none";
        }
});
riot.tag2('osd', '<div ref="osd-ctrl" class="osd error"> <label style="margin: 0 auto; padding: 0;"></label> </div>', 'osd,[data-is="osd"]{ display: inline-block; position: absolute; margin: 0 auto; padding: 0; left: 50px; right: 50px; bottom: 50px; z-index: 1000; background-color: transparent; } osd .osd,[data-is="osd"] .osd{ display: block; position: relative; margin: 0 auto; padding: 5px; height: auto; width: 200px; color: white; background-color: rgba(0, 0, 0, .7); text-align: center; border: 1; border-color: rgba(0, 0, 0, 1); border-radius: 8px; user-select: none; visibility: hidden; } osd .osd.show,[data-is="osd"] .osd.show{ visibility: visible; } osd .osd.show.info,[data-is="osd"] .osd.show.info{ color: whitesmoke; background-color: rgba(0, 0, 0, .7); border-color: rgba(0, 0, 0, 1); } osd .osd.show.warn,[data-is="osd"] .osd.show.warn{ color: black; background-color: rgba(255, 255, 0, .7); border-color: rgba(255, 255, 0, 1); } osd .osd.show.error,[data-is="osd"] .osd.show.error{ color: yellow; background-color: rgba(255, 0, 0, .7); border-color: rgba(255, 0, 0, 1); }', '', function(opts) {


        let self = this;

        let ctrl;
        let initCtrls = () => {
            ctrl = self.refs['osd-ctrl']
        }
        let freeCtrls = () => {
            ctrl = null;
        }

        let addEvt = (evtName, handle) => { document.addEventListener(evtName, handle) }
        let delEvt = (evtName, handle) => { document.removeEventListener(evtName, handle) }

        let bindEvents = () => {
            addEvt(events.name.ShowOsd, showOsd)
            addEvt(events.name.UpdateOsd, updateOsd)
            addEvt(events.name.HideOsd, hideOsd)
        }
        let unbindEvents = () => {
            delEvt(events.name.HideOsd, hideOsd)
            delEvt(events.name.UpdateOsd, updateOsd)
            delEvt(events.name.ShowOsd, showOsd)
        }

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            freeCtrls();
        });

        let showOsd = () => {
            ctrl.classList.add('show')
            self.update();
        }
        let updateOsd = (e) => {
            let data = e.detail.data;
            ctrl.innerHTML = data.msg;
            if (data.type === 'warn') {
                ctrl.classList.remove('info')
                ctrl.classList.add('warn')
                ctrl.classList.remove('error')
            }
            else if (data.type === 'error') {
                ctrl.classList.remove('info')
                ctrl.classList.remove('warn')
                ctrl.classList.add('error')
            }
            else {
                ctrl.classList.add('info')
                ctrl.classList.remove('warn')
                ctrl.classList.remove('error')
            }
            self.update();
        }
        let hideOsd = () => {
            ctrl.innerHTML = '';
            ctrl.classList.remove('info')
            ctrl.classList.remove('warn')
            ctrl.classList.remove('error')
            ctrl.classList.remove('show')
            self.update();
        }
});
riot.tag2('tabcontrol', '', 'tabcontrol,[data-is="tabcontrol"]{ position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: auto 1fr; grid-template-areas: \'tab-headers\' \'tab-pages\'; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: transparent; } tabcontrol tabheaders:first-child,[data-is="tabcontrol"] tabheaders:first-child{ grid-area: tab-headers; display: block; } tabcontrol :not(tabheaders:first-child),[data-is="tabcontrol"] :not(tabheaders:first-child){ display: none; } tabcontrol tabpages:last-child,[data-is="tabcontrol"] tabpages:last-child{ grid-area: tab-pages; display: block; } tabcontrol :not(tabpages:last-child),[data-is="tabcontrol"] :not(tabpages:last-child){ display: none; }', '', function(opts) {
        let self = this;
        let headers = null;
        let panels = null;

        let initCtrls = () => {
            headers = self.tags['tabheaders']
            panels = self.tags['tabpages']
        }
        let freeCtrls = () => {
            panels = null;
            headers = null;
        }

        this.on('mount', () => { initCtrls(); });
        this.on('unmount', () => { freeCtrls(); });

        updateHeaders = (tabName) => {

            if (headers) {
                headers.show(tabName)
            }
        }

        updatePanels = (tabName) => {

            if (panels) {
                panels.show(tabName)
            }
        }

        this.setActiveTab = (tabName) => {
            updateHeaders(tabName);
            updatePanels(tabName);
        }
});

riot.tag2('tabheader', '<yield></yield>', 'tabheader,[data-is="tabheader"]{ float: left; margin: 0 auto; padding: 4px 16px; margin-top: 2px; vertical-align: baseline; border: 0px solid silver; border-bottom: 0px; border-radius: 6px 6px 0 0; color: navy; background: silver; cursor: pointer; transition: 0.3s; user-select: none; white-space: nowrap; overflow: hidden; } tabheader:hover,[data-is="tabheader"]:hover{ color: whitesmoke; background: forestgreen; border-color: green; } tabheader.active,[data-is="tabheader"].active{ color: whitesmoke; background: cornflowerblue; border-color: royalblue; }', '', function(opts) {
        let self = this;

        let bindEvents = () => {
            self.root.addEventListener('click', headerClick)
        }
        let unbindEvents = () => {
            self.root.removeEventListener('click', headerClick)
        }

        this.on('mount', () => { bindEvents(); });
        this.on('unmount', () => { unbindEvents(); });

        let headerClick = (evt) => {
            let tabName = self.getTabName();
            self.parent.setActiveTab(tabName)
        }

        this.getTabName = () => {
            let ret = self.root.getAttribute('for').toLowerCase().trim()
            return ret
        }
        this.show = () => {
            self.root.classList.add('active')
        }
        this.hide = () => {
            self.root.classList.remove('active')
        }
});
riot.tag2('tabheaders', '<yield></yield>', 'tabheaders,[data-is="tabheaders"]{ position: relative; display: flex; align-items: baseline; justify-content: space-between; margin: 0; padding: 0; width: 100%; height: auto; border: none; background-color: transparent; overflow: hidden; } tabheaders>:not(tabheader),[data-is="tabheaders"]>:not(tabheader){ display: none; }', '', function(opts) {
        let self = this;
        let headers = null;

        let initCtrls = () => {
            headers = self.tags['tabheader']
            if (headers && headers.length > 0) headers[0].show();
        }
        let freeCtrls = () => { headers = null; }

        this.on('mount', () => { initCtrls(); });
        this.on('unmount', () => { freeCtrls(); });

        this.show = (tabName) => {
            let activeHeader = null;
            let activeName = tabName.toLowerCase().trim();

            for (i = 0; i < headers.length; i++) {
                let headerName = headers[i].getTabName()
                if (headerName === activeName) {
                    headers[i].show();
                }
                else {
                    headers[i].hide();
                }
            }
        }

        this.setActiveTab = (tabName) => {
            self.parent.setActiveTab(tabName)
        }
});
riot.tag2('tabpage', '<yield></yield>', 'tabpage,[data-is="tabpage"]{ display: none; margin: 0; padding: 0; width: 100%; height: 100%; border: 0 solid silver; overflow: auto; animation: fadeEffect 2s; } @keyframes fadeEffect { from { opacity: 0; } to { opacity: 1; } } tabpage.active,[data-is="tabpage"].active{ display: block; }', '', function(opts) {
        let self = this;

        this.getTabName = () => {
            let ret = self.root.getAttribute('name').toLowerCase().trim()
            return ret
        }
        this.show = () => { self.root.classList.add('active') }
        this.hide = () => { self.root.classList.remove('active') }
});

riot.tag2('tabpages', '<yield></yield>', 'tabpages,[data-is="tabpages"]{ display: none; margin: 0; padding: 0; padding-top: 2px; width: 100%; height: 100%; border: 1px solid silver; overflow: hidden; } tabpages.active,[data-is="tabpages"].active{ display: block; } tabpages>:not(tabpage),[data-is="tabpages"]>:not(tabpage){ display: none; }', '', function(opts) {
        let self = this;
        let panels = null;

        let initCtrls = () => {
            panels = self.tags['tabpage']
            if (panels && panels.length > 0) panels[0].show();
        }
        let freeCtrls = () => { panels = null; }

        this.on('mount', () => { initCtrls(); });
        this.on('unmount', () => { freeCtrls(); });

        this.show = (tabName) => {
            let activeName = tabName.toLowerCase().trim();

            for (i = 0; i < panels.length; i++) {
                let panelName = panels[i].getTabName()
                if (panelName === activeName) {
                    panels[i].show();
                }
                else {
                    panels[i].hide();
                }
            }
        }
});
riot.tag2('ncheckedtree', '<div class="ntree-container"> <div ref="tree" class="tree"></div> </div> <label>{opts.title}</label>', 'ncheckedtree,[data-is="ncheckedtree"]{ margin: 0; margin-top: 5px; padding: 10px; font-size: 14px; display: inline-block; position: relative; height: auto; width: 100%; background: transparent; box-shadow: 0 5px 10px solid rgba(0, 0, 0, .2); } ncheckedtree .ntree-container,[data-is="ncheckedtree"] .ntree-container{ display: block; padding: 20px 0 10px 0; margin-bottom: 0px; width: calc(100% - 25px); background-color: whitesmoke; box-sizing: border-box; box-shadow: none; outline: none; border: none; font-size: 14px; box-shadow: 0 0 0px 1000px white inset; border-radius: 2px; border-bottom: 2px solid cornflowerblue; overflow: hidden; } ncheckedtree .ntree-container .tree,[data-is="ncheckedtree"] .ntree-container .tree{ width: 100%; border: 1px solid silver; border-radius: 2px; height: 100px; min-height: 100px; max-height: 100px; overflow: auto; } ncheckedtree label,[data-is="ncheckedtree"] label{ position: absolute; top: 5px; left: 10px; transition: .2s; pointer-events: none; color: cornflowerblue; font-weight: bold; }', '', function(opts) {


        let self = this;
        let fldmap = { valueField:'id', textField:'text', parentField: '#' }
        let selectItemsCallback;

        let tree, clear;

        let initCtrls = () => {
            tree = self.refs['tree'];
            self.setup();
        }
        let freeCtrls = () => {
            tree = null;
        }
        let clearInputs = () => {
            if (tree) {
                $(tree).jstree().deselect_node(this);
            }
        }

        let bindEvents = () => {}
        let unbindEvents = () => {}

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            clearInputs();
        });

        this.clear = () => { clearInputs(); }
        this.focus = () => { if (tree) tree.focus(); }

        let hasValue = (val) => {
            return (val !== undefined && val !== null);
        }
        let setSelectedItems = (items) => {
            if (tree && items && items.length > 0) {
                let map = items.map(item => { return item.id })
                $(tree).jstree(true).check_node(map)
            }
        }
        let getSelectedItems = () => {
            let ret = [];
            if (tree) {
                ret = $(tree).jstree(true).get_checked(true);
            }
            return ret;
        }
        this.selectedItems = (items) => {
            let ret;
            if (tree) {
                if (hasValue(items)) {
                    setSelectedItems(items);
                }
                else {
                    ret = getSelectedItems();
                }
            }
            return ret;
        }
        this.setup = (values, fldMap) => {
            if (tree) {
                fldmap = fldMap;
                let data = [];
                if (values) {
                    values.forEach(val => {
                        let item = {
                            id: String(val[fldmap.valueField]),
                            text: val[fldmap.textField],
                            parent: '#'
                        }
                        if (fldmap.parentField && val[fldmap.parentField]) {

                            item.parent = val[fldmap.parentField];
                        }
                        item.data = val;
                        data.push(item);
                    });
                }

                $(tree).jstree("destroy");
                $(tree).jstree({
                    'core': {
                        data: data,
                        "multiple" : true
                    },
                    "checkbox" : { "keep_selected_style" : false, two_state: true },
                    "plugins" : [ "wholerow", "checkbox", "json_data" ]
                }).on('ready.jstree', () => {
                    $(tree).jstree("open_all");
                    $(tree).on('changed.jstree', (e, data) => {
                        let i, j, r = [];
                        for (i = 0, j = data.selected.length; i < j; i++) {

                            r.push(data.instance.get_node(data.selected[i]));
                        }

                        if (selectItemsCallback && r.length > 0) {
                            selectItemsCallback(r)
                        }
                    });
                });
            }
            self.update();
        }

        this.onSelectItems = (callback) => {

            selectItemsCallback = callback

        }
});

riot.tag2('norgtree', '<div class="org-tree-container" ref="orgtree"></div>', 'norgtree,[data-is="norgtree"]{ margin: 0 auto; padding: 0; width: 100%; height: 100%; overflow: hidden; } norgtree .org-tree-container,[data-is="norgtree"] .org-tree-container{ margin: 0 auto; padding: 0; width: 100%; height: 100%; overflow: hidden; } norgtree .org-tree-container .orgchart,[data-is="norgtree"] .org-tree-container .orgchart{ position: relative; display: inline-block; margin: 0 auto; padding: 0; width: 100%; height: 100%; overflow: auto; }', '', function(opts) {
        let self = this;
        let datasource = {
            'name': 'Lao Lao',
            'title': 'general manager',
            'children': [
                {
                    'name': 'Bo Miao', 'title': 'department manager', 'collapsed': true,
                    'children': [
                        { 'name': 'Li Jing', 'title': 'senior engineer', 'className': 'slide-up' },
                        {
                            'name': 'Li Xin', 'title': 'senior engineer', 'collapsed': true, 'className': 'slide-up',
                            'children': [
                                { 'name': 'To To', 'title': 'engineer', 'className': 'slide-up' },
                                { 'name': 'Fei Fei', 'title': 'engineer', 'className': 'slide-up' },
                                { 'name': 'Xuan Xuan', 'title': 'engineer', 'className': 'slide-up' }
                            ]
                        }
                    ]
                },
                {
                    'name': 'Su Miao', 'title': 'department manager',
                    'children': [
                        { 'name': 'Pang Pang', 'title': 'senior engineer' },
                        {
                            'name': 'Hei Hei', 'title': 'senior engineer', 'collapsed': true,
                            'children': [
                                { 'name': 'Xiang Xiang', 'title': 'UE engineer', 'className': 'slide-up' },
                                { 'name': 'Dan Dan', 'title': 'engineer', 'className': 'slide-up' },
                                { 'name': 'Zai Zai', 'title': 'engineer', 'className': 'slide-up' }
                            ]
                        }
                    ]
                }
            ]
        };
        let updatecontent = () => {
            if (orgtree) {
                $(orgtree).orgchart({
                    'data': datasource,
                    'nodeContent': 'title'
                });
            }
            else {

            }
            self.update();
        }

        let orgtree;

        let initCtrls = () => {
            orgtree = self.refs['orgtree'];

            self.refresh()
        }
        let freeCtrls = () => {
            orgtree = null;
        }

        let addEvt = (evtName, handle) => { document.addEventListener(evtName, handle) }
        let delEvt = (evtName, handle) => { document.removeEventListener(evtName, handle) }

        let bindEvents = () => {

        }
        let unbindEvents = () => {

        }

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            freeCtrls();
        });

        this.refresh = () => {
            updatecontent()
        }

});
riot.tag2('ntree', '<div class="ntree-container"> <div ref="tree" class="tree"></div> </div> <label>{opts.title}</label>', 'ntree,[data-is="ntree"]{ margin: 0; margin-top: 5px; padding: 10px; font-size: 14px; display: inline-block; position: relative; height: auto; width: 100%; background: transparent; box-shadow: 0 5px 10px solid rgba(0, 0, 0, .2); } ntree .ntree-container,[data-is="ntree"] .ntree-container{ display: block; padding: 20px 0 10px 0; margin-bottom: 0px; width: calc(100% - 25px); background-color: whitesmoke; box-sizing: border-box; box-shadow: none; outline: none; border: none; font-size: 14px; box-shadow: 0 0 0px 1000px white inset; border-radius: 2px; border-bottom: 2px solid cornflowerblue; overflow: hidden; } ntree .ntree-container .tree,[data-is="ntree"] .ntree-container .tree{ width: 100%; border: 1px solid silver; border-radius: 2px; height: 100px; min-height: 100px; max-height: 100px; overflow: auto; } ntree label,[data-is="ntree"] label{ position: absolute; top: 5px; left: 10px; transition: .2s; pointer-events: none; color: cornflowerblue; font-weight: bold; }', '', function(opts) {


        let self = this;
        let fldmap = { valueField:'id', textField:'text', parentField: '#' }
        let selectItemCallback;

        let tree, clear;

        let initCtrls = () => {
            tree = self.refs['tree'];
            self.setup();
        }
        let freeCtrls = () => {
            tree = null;
        }
        let clearInputs = () => {
            if (tree) {
                $(tree).jstree().deselect_node(this);
            }
        }

        let bindEvents = () => {}
        let unbindEvents = () => {}

        this.on('mount', () => {
            initCtrls();
            bindEvents();
        });
        this.on('unmount', () => {
            unbindEvents();
            clearInputs();
        });

        this.clear = () => { clearInputs(); }
        this.focus = () => { if (tree) tree.focus(); }

        let hasValue = (val) => {
            return (val !== undefined && val !== null);
        }
        let setSelectedItem = (item) => {
            console.log('set selected item.')
            if (tree && item) {

                $(tree).jstree(true).select_node(item);

            }
        }
        let getSelectedItem = () => {
            let ret = null;
            if (tree) {
                let selectitems = $(tree).jstree(true).get_selected();
                ret = (selectitems && selectitems.length > 0) ? selectitems[0] : null;
            }
            return ret;
        }
        this.selectedItem = (item) => {
            let ret;
            if (tree) {
                if (hasValue(item)) {
                    setSelectedItem(item);
                }
                else {
                    ret = getSelectedItem();
                }
            }
            return ret;
        }
        this.setup = (values, fldMap, lastValue) => {
            if (tree) {
                fldmap = fldMap;
                let data = [];
                if (values) {
                    values.forEach(val => {
                        let item = {
                            id: String(val[fldmap.valueField]),
                            text: val[fldmap.textField],
                            parent: '#'
                        }
                        if (lastValue) {
                            item.state = { selected: true }
                        }
                        if (fldmap.parentField && val[fldmap.parentField]) {

                            item.parent = val[fldmap.parentField];
                        }
                        item.data = val;
                        data.push(item);
                    });
                }

                $(tree).jstree("destroy");
                $(tree).jstree({
                    'core': {
                        data: data,
                        "multiple" : false
                    },

                    "plugins" : [ "wholerow", "json_data" ]
                }).on('ready.jstree', () => {
                    $(tree).jstree("open_all");
                    $(tree).on('changed.jstree', (e, data) => {
                        let i, j, r = [];
                        for (i = 0, j = data.selected.length; i < j; i++) {

                            r.push(data.instance.get_node(data.selected[i]));
                        }

                        if (selectItemCallback && r.length > 0) {
                            selectItemCallback(r[0])
                        }
                    });
                });
            }
            self.update();
        }

        this.onSelectItem = (callback) => {

            selectItemCallback = callback

        }
});

riot.tag2('collapse-panel', '<div class="panel-container"> <div class="panel-header"> <div class="collapse-button" onclick="{collapseClick}"> <virtual if="{!collapsed}"> <span class="fas fa-sort-down" style="padding-left: 2px; transform: translate(0px, -3px);"></span> </virtual> <virtual if="{collapsed}"> <span class="fas fa-caret-right" style="padding-left: 4px;"></span> </virtual> </div> <div class="header-block"> <label>{opts.caption}</label> </div> <virtual if="{\'removable\' in opts}"> <div class="close-button" onclick="{closeClick}"> <span class="far fa-times-circle" style="transform: translate(5px, 0);"></span> </div> </virtual> </div> <div ref="content" class="panel-body"> <yield></yield> </div> </div>', 'collapse-panel,[data-is="collapse-panel"]{ margin: 0 auto; padding: 0; width: 100%; font-size: smaller; } collapse-panel .panel-container,[data-is="collapse-panel"] .panel-container{ margin: 0; padding: 2px; width: 100%; display: grid; grid-template-columns: 1fr; grid-template-rows: auto 1fr; grid-template-areas: \'panel-header\' \'panel-body\'; } collapse-panel .panel-header,[data-is="collapse-panel"] .panel-header{ grid-area: panel-header; display: grid; margin: 0; padding: 0; padding-left: 3px; padding-right: 3px; width: 100%; grid-template-columns: 22px 1fr 20px; grid-template-rows: 1fr; grid-template-areas: \'collapse-button header-block close-button\'; color: white; align-self: center; border-radius: 5px 5px 0 0; background-color: cornflowerblue; } collapse-panel .panel-header .collapse-button,[data-is="collapse-panel"] .panel-header .collapse-button{ grid-area: collapse-button; align-self: center; margin: 0; padding: 0; width: 100%; cursor: pointer; } collapse-panel .panel-header .collapse-button:hover,[data-is="collapse-panel"] .panel-header .collapse-button:hover{ color: yellow; } collapse-panel .panel-header .header-block,[data-is="collapse-panel"] .panel-header .header-block{ grid-area: header-block; align-self: center; align-content: center; margin: 0; padding: 0; width: 100%; cursor: none; } collapse-panel .panel-header .header-block:hover,[data-is="collapse-panel"] .panel-header .header-block:hover{ color: yellow; } collapse-panel .panel-header .header-block label,[data-is="collapse-panel"] .panel-header .header-block label{ margin: 0; margin-bottom: 1px; padding: 0; width: 100%; user-select: none; } collapse-panel .panel-header .close-button,[data-is="collapse-panel"] .panel-header .close-button{ grid-area: close-button; align-self: center; margin: 0; padding: 0; width: 100%; cursor: pointer; } collapse-panel .panel-header .close-button:hover,[data-is="collapse-panel"] .panel-header .close-button:hover{ color: orangered; } collapse-panel .panel-body,[data-is="collapse-panel"] .panel-body{ grid-area: panel-body; display: inline-block; margin: 0; padding: 3px; padding-top: 3px; padding-bottom: 3px; width: 100%; background-color: white; border: 1px solid cornflowerblue; } collapse-panel .panel-container .panel-body.collapsed,[data-is="collapse-panel"] .panel-container .panel-body.collapsed{ display: none; }', '', function(opts) {
        let self = this;
        let collapsed = false;
        let contentPanel;
        this.collapseClick = (e) => {

            contentPanel = self.refs['content'];
            if (contentPanel) {
                contentPanel.classList.toggle('collapsed')
                if (contentPanel.classList.contains('collapsed'))
                    self.collapsed = true;
                else self.collapsed = false;
            }
        };
        this.closeClick = (e) => {
            let tagEl = self.root;
            let parentEl = (tagEl) ? tagEl.parentElement : null;
            if (parentEl) {
                parentEl.removeChild(tagEl)
            }
        };
});
riot.tag2('napp', '<div class="app-area"> <yield></yield> </div>', 'napp,[data-is="napp"]{ display: grid; margin: 0 auto; padding: 0; height: 100vh; width: 100vw; grid-template-areas: \'app-area\'; background: inherit; overflow: hidden; } napp>.app-area,[data-is="napp"]>.app-area{ grid-area: app-area; position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: auto 1fr auto; grid-template-areas: \'navi-area\' \'scrn-area\' \'stat-area\'; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; } napp>.app-area>:not(navibar):not(screen):not(statusbar),[data-is="napp"]>.app-area>:not(navibar):not(screen):not(statusbar){ display: none; } napp>.app-area navibar:first-child,[data-is="napp"]>.app-area navibar:first-child{ grid-area: navi-area; } napp>.app-area navibar:not(:first-child),[data-is="napp"]>.app-area navibar:not(:first-child){ grid-area: navi-area; display: none; } napp>.app-area screen,[data-is="napp"]>.app-area screen{ grid-area: scrn-area; } napp>.app-area statusbar:last-child,[data-is="napp"]>.app-area statusbar:last-child{ grid-area: stat-area; } napp>.app-area statusbar:not(:last-child),[data-is="napp"]>.app-area statusbar:not(:last-child){ grid-area: stat-area; display: none; }', '', function(opts) {
});
riot.tag2('screen', '<div class="content-area"> <yield></yield> </div>', 'screen,[data-is="screen"]{ margin: 0 auto; padding: 0; display: none; width: 100%; height: 100%; } screen.active,[data-is="screen"].active,screen.show,[data-is="screen"].show{ display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'content-area\'; } screen .content-area,[data-is="screen"] .content-area{ width: 100%; height: 100%; overflow: hidden; }', '', function(opts) {


        let self = this;

        let hide = () => { self.root.classList.remove('show') }
        let show = () => { self.root.classList.add('show') }

        let updatecontent = () => {
            if (screens.current.screenId !== self.opts.screenid) {
                hide();
            }
            else {
                show();
            }
            self.update();
        }

        let addEvt = (evtName, handle) => { document.addEventListener(evtName, handle) }
        let delEvt = (evtName, handle) => { document.removeEventListener(evtName, handle) }

        let bindEvents = () => {
            addEvt(events.name.ScreenChanged, onScreenChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ScreenChanged, onScreenChanged)
        }

        this.on('mount', () => { bindEvents(); });
        this.on('unmount', () => { unbindEvents(); });

        let onScreenChanged = (e) => { updatecontent(); }

});
riot.tag2('tool-window', '<div class="window-container"> <div class="window-header"> <div ref="dragger" class="header-block"> <label>{opts.caption}</label> </div> </div> <div ref="content" class="window-body"> <yield></yield> </div> </div>', 'tool-window,[data-is="tool-window"]{ display: block; position: absolute; z-index: 9; margin: 0; width: 25%; min-width: 100px; height: 90%; overflow: none; } tool-window .window-container,[data-is="tool-window"] .window-container{ grid-area: panel-container; width: 100%; height: 100%; padding: 5px; display: grid; grid-template-columns: 1fr; grid-template-rows: 30px auto; grid-template-areas: \'panel-header\' \'panel-body\'; overflow: none; } tool-window .window-container .window-header,[data-is="tool-window"] .window-container .window-header{ grid-area: panel-header; display: grid; margin: 0; padding: 0; padding-left: 3px; padding-right: 3px; width: 100%; height: 100%; grid-template-columns: auto 1fr; grid-template-rows: 1fr; grid-template-areas: \'collapse-button header-block\'; color: white; border-radius: 5px 5px 0 0; background-color: cornflowerblue; overflow: none; } tool-window .window-header .collapse-button,[data-is="tool-window"] .window-header .collapse-button{ grid-area: collapse-button; align-self: center; margin: 0; padding: 0; width: 100%; cursor: pointer; } tool-window .window-header .collapse-button:hover,[data-is="tool-window"] .window-header .collapse-button:hover{ color: yellow; } tool-window .window-header .header-block,[data-is="tool-window"] .window-header .header-block{ grid-area: header-block; align-self: center; align-content: center; margin: 0; padding: 0; padding-left: 3px; width: 100%; cursor: none; } tool-window .window-header .header-block:hover,[data-is="tool-window"] .window-header .header-block:hover{ color: yellow; } tool-window .window-header .header-block label,[data-is="tool-window"] .window-header .header-block label{ margin-top: 3px; padding: 0; width: 100%; height: 100%; user-select: none; } tool-window .window-container .window-body,[data-is="tool-window"] .window-container .window-body{ grid-area: panel-body; margin: 0; padding: 3px; padding-top: 5px; padding-bottom: 5px; width: 100%; height: 100%; background-color: white; border: 1px solid cornflowerblue; overflow: auto; } tool-window .window-container .window-body.collapsed,[data-is="tool-window"] .window-container .window-body.collapsed{ display: none; }', '', function(opts) {


        let self = this;
        let collapsed = false;

        let selfEl;

        let contentPanel, dragger;

        this.on('mount', () => {
            contentPanel = self.refs['content'];
            dragger = self.refs['dragger'];
            selfEl = self.root;
            dragElement();
        });
        this.on('unmount', () => {
            selfEl = null;
            contentPanel = null;
            dragger = null;
        });

        this.collapseClick = (e) => {

            if (contentPanel) {
                contentPanel.classList.toggle('collapsed')
                if (contentPanel.classList.contains('collapsed'))
                    self.collapsed = true;
                else self.collapsed = false;
            }
        };

        let pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;

        let dragElement = () => {
            if (dragger) {
                dragger.onmousedown = dragMouseDown;
            }
        }

        let dragMouseDown = (e) => {
            e = e || window.event;
            e.preventDefault();

            pos3 = e.clientX;
            pos4 = e.clientY;
            document.onmouseup = closeDragElement;

            document.onmousemove = elementDrag;
        }

        let elementDrag = (e) => {
            e = e || window.event;
            e.preventDefault();

            pos1 = pos3 - e.clientX;
            pos2 = pos4 - e.clientY;
            pos3 = e.clientX;
            pos4 = e.clientY;

            selfEl.style.top = (selfEl.offsetTop - pos2) + "px";
            selfEl.style.left = (selfEl.offsetLeft - pos1) + "px";
        }

        let closeDragElement = () => {

            document.onmouseup = null;
            document.onmousemove = null;
        }

});
riot.tag2('navi-item', '<yield></yield>', 'navi-item,[data-is="navi-item"]{ position: relative; display: inline-block; margin: 2px; padding: 2px; font-size: 1.1rem; vertical-align: baseline; cursor: default; user-select: none; white-space: nowrap; overflow: hidden; } navi-item.center,[data-is="navi-item"].center{ flex-grow: 1; text-align: center; } navi-item.right,[data-is="navi-item"].right{ justify-self: flex-end; }', '', function(opts) {
});
riot.tag2('navibar', '<yield></yield>', 'navibar,[data-is="navibar"]{ position: relative; display: flex; align-items: baseline; justify-content: space-between; margin: 0; padding: 1px 4px; width: 100%; color: white; background: cornflowerblue; overflow: hidden; }', '', function(opts) {
});
riot.tag2('statusbar', '<yield></yield>', 'statusbar,[data-is="statusbar"]{ position: relative; display: block; margin: 0; padding: 0; width: 100%; user-select: none; white-space: nowrap; overflow: hidden; }', '', function(opts) {
});