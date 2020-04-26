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
riot.tag2('tabcontrol', '<div class="tabcontrol-wrapper"> <yield></yield> </div>', 'tabcontrol,[data-is="tabcontrol"]{ position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'tabcontrol-wrapper\'; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; background: transparent; } tabcontrol>.tabcontrol-wrapper,[data-is="tabcontrol"]>.tabcontrol-wrapper{ grid-area: tabcontrol-wrapper; position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: auto 1fr; grid-template-areas: \'tab-headers\' \'tab-pages\'; margin: 0; padding: 5px; padding-right: 10px; width: 100%; height: 100%; overflow: hidden; background: transparent; } tabcontrol>.tabcontrol-wrapper tabheaders:first-child,[data-is="tabcontrol"]>.tabcontrol-wrapper tabheaders:first-child{ grid-area: tab-headers; position: relative; display: inline-block; margin: 0; padding: 0; width: 100%; height: 100%; } tabcontrol>.tabcontrol-wrapper :not(tabheaders:first-child),[data-is="tabcontrol"]>.tabcontrol-wrapper :not(tabheaders:first-child){ display: none; } tabcontrol>.tabcontrol-wrapper tabpages:last-child,[data-is="tabcontrol"]>.tabcontrol-wrapper tabpages:last-child{ grid-area: tab-pages; position: relative; display: inline-block; margin: 0; padding: 0; width: 100%; height: 100%; box-shadow: var(--tabpages-box-shadow); } tabcontrol>.tabcontrol-wrapper :not(tabpages:last-child),[data-is="tabcontrol"]>.tabcontrol-wrapper :not(tabpages:last-child){ display: none; }', '', function(opts) {
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

riot.tag2('tabheader', '<yield></yield>', 'tabheader,[data-is="tabheader"]{ float: left; margin: 0 auto; padding: 4px 16px; margin-top: 2px; vertical-align: baseline; border: 0px solid var(--tabheader-border-color); border-bottom: 0px; border-radius: 6px 6px 0 0; color: var(--tabheader-foreground-color); background: var(--tabheader-background-color); cursor: pointer; transition: 0.3s; user-select: none; white-space: nowrap; overflow: hidden; } tabheader:hover,[data-is="tabheader"]:hover{ color: whitesmoke; background: var(--tabheader-hover-background-color); border-color: var(--tabheader-hover-border-color); } tabheader.active,[data-is="tabheader"].active{ color: whitesmoke; background: var(--tabheader-active-background-color); border-color: var(--tabheader-active-border-color); }', '', function(opts) {
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
riot.tag2('tabpage', '<div class="tab-content-wrapper"> <div class="tab-content-area"> <yield></yield> </div> </div>', 'tabpage,[data-is="tabpage"]{ position: relative; display: none; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; animation: fadeEffect 2s; } @keyframes fadeEffect { from { opacity: 0; } to { opacity: 1; } } tabpage.active,[data-is="tabpage"].active{ display: block; } tabpage>.tab-content-wrapper,[data-is="tabpage"]>.tab-content-wrapper{ position: absolute; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; } tabpage>.tab-content-wrapper>.tab-content-area,[data-is="tabpage"]>.tab-content-wrapper>.tab-content-area{ position: relative; margin: 0; padding: 0; width: 100%; height: 100%; overflow: auto; }', '', function(opts) {
        let self = this;

        this.getTabName = () => {
            let ret = self.root.getAttribute('name').toLowerCase().trim()
            return ret
        }
        this.show = () => { self.root.classList.add('active') }
        this.hide = () => { self.root.classList.remove('active') }
});

riot.tag2('tabpages', '<yield></yield>', 'tabpages,[data-is="tabpages"]{ display: none; border: 1px dotted silver; overflow: hidden; } tabpages.active,[data-is="tabpages"].active{ display: block; margin: 0; padding: 0; padding-top: 2px; width: 100%; height: 100%; } tabpages>:not(tabpage),[data-is="tabpages"]>:not(tabpage){ display: none; }', '', function(opts) {
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

riot.tag2('card-container', '<div class="card-container-wrapper"> <yield></yield> </div>', 'card-container,[data-is="card-container"]{ position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'card-container-area\'; margin: 0; padding: 5px; padding-right: 10px; width: 100%; height: 100%; overflow: hidden; } card-container>.card-container-wrapper,[data-is="card-container"]>.card-container-wrapper{ grid-area: card-container-area; position: absolute; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; overflow-y: auto; } card-container[shadow]>.card-container-wrapper,[data-is="card-container"][shadow]>.card-container-wrapper{ box-shadow: var(--card-box-shadow); }', '', function(opts) {
});
riot.tag2('card-item', '<div class="card-item-wrapper"> <yield></yield> </div>', 'card-item,[data-is="card-item"]{ position: relative; display: inline-block; margin: 0; padding: 5px; padding-bottom: 10px; } card-item>.card-item-wrapper,[data-is="card-item"]>.card-item-wrapper{ position: relative; display: inline-block; margin: 0 auto; padding: 0; width: 100%; height: 100%; } card-item[shadow]>.card-item-wrapper,[data-is="card-item"][shadow]>.card-item-wrapper{ box-shadow: var(--card-box-shadow); }', '', function(opts) {
});
riot.tag2('card-row', '<div class="card-row-wrapper"> <div class="card-row-area"> <yield></yield> </div> </div>', 'card-row,[data-is="card-row"]{ position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'card-row-area\'; margin: 0; padding: 5px; padding-right: 10px; width: 100%; height: auto; } card-row>.card-row-wrapper,[data-is="card-row"]>.card-row-wrapper{ grid-area: card-row-area; position: relative; display: block; margin: 0 auto; padding: 0; width: 100%; height: auto; } card-row[shadow]>.card-row-wrapper,[data-is="card-row"][shadow]>.card-row-wrapper{ box-shadow: var(--card-box-shadow); } card-row>.card-row-wrapper>.card-row-area,[data-is="card-row"]>.card-row-wrapper>.card-row-area{ position: relative; margin: 0 auto; padding: 0; width: 100%; height: auto; }', '', function(opts) {
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
riot.tag2('dual-layout', '<div ref="flipper" class="dual-layout-container"> <div class="left-block"> <div class="content"> <yield from="left-panel"></yield> </div> </div> <div class="right-block"> <div class="content"> <yield from="right-panel"></yield> </div> </div> </div>', 'dual-layout,[data-is="dual-layout"]{ position: relative; display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'dual-area\'; margin: 0; padding: 5px; padding-right: 10px; width: 100%; height: 100%; overflow: hidden; } dual-layout>.dual-layout-container,[data-is="dual-layout"]>.dual-layout-container{ grid-area: dual-area; position: relative; display: block; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; } dual-layout>.dual-layout-container.toggle,[data-is="dual-layout"]>.dual-layout-container.toggle{ transform: none; } @media only screen and (min-width: 700px) { dual-layout>.dual-layout-container,[data-is="dual-layout"]>.dual-layout-container{ grid-area: dual-area; position: relative; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: 1fr; grid-template-areas: \'left-area right-area\'; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; } } dual-layout[shadow].dual-layout-container,[data-is="dual-layout"][shadow].dual-layout-container{ box-shadow: var(--card-box-shadow); } dual-layout>.dual-layout-container .left-block,[data-is="dual-layout"]>.dual-layout-container .left-block,dual-layout>.dual-layout-container .right-block,[data-is="dual-layout"]>.dual-layout-container .right-block{ position: absolute; display: inline-block; opacity: 1; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; } dual-layout>.dual-layout-container .left-block,[data-is="dual-layout"]>.dual-layout-container .left-block{ transition: opacity 1s ease-in-out; opacity: 1; } dual-layout>.dual-layout-container.toggle .left-block,[data-is="dual-layout"]>.dual-layout-container.toggle .left-block{ transition: opacity .5s ease-in-out; opacity: 0; } dual-layout>.dual-layout-container .right-block,[data-is="dual-layout"]>.dual-layout-container .right-block{ opacity: 0; transition: opacity .5s ease-in-out; } dual-layout>.dual-layout-container.toggle .right-block,[data-is="dual-layout"]>.dual-layout-container.toggle .right-block{ transition: opacity 1s ease-in-out; opacity: 1; } dual-layout>.dual-layout-container .left-block .content,[data-is="dual-layout"]>.dual-layout-container .left-block .content,dual-layout>.dual-layout-container .right-block .content,[data-is="dual-layout"]>.dual-layout-container .right-block .content{ position: relative; display: inline-block; margin: 0 auto; padding: 0; width: 100%; height: 100%; overflow: hidden; } @media only screen and (min-width: 720px) { dual-layout>.dual-layout-container .left-block,[data-is="dual-layout"]>.dual-layout-container .left-block,dual-layout>.dual-layout-container .right-block,[data-is="dual-layout"]>.dual-layout-container .right-block,dual-layout>.dual-layout-container.toggle .left-block,[data-is="dual-layout"]>.dual-layout-container.toggle .left-block,dual-layout>.dual-layout-container.toggle .right-block,[data-is="dual-layout"]>.dual-layout-container.toggle .right-block{ opacity: 1; backface-visibility: initial; transform-style: initial; transform: none; } dual-layout>.dual-layout-container .left-block,[data-is="dual-layout"]>.dual-layout-container .left-block{ grid-area: left-area; } dual-layout>.dual-layout-container .right-block,[data-is="dual-layout"]>.dual-layout-container .right-block{ grid-area: right-area; } }', '', function(opts) {
        let self = this;

        this.on('mount', () => {
            flipper = self.refs['flipper']
        })
        this.on('unmount', () => {
            flipper = null
        })

        this.toggle = () => {
            flipper.classList.toggle('toggle');
        }
});
riot.tag2('napp', '<div class="app-area"> <yield></yield> </div>', 'napp,[data-is="napp"]{ display: grid; margin: 0 auto; padding: 0; height: 100vh; width: 100vw; grid-template-areas: \'app-area\'; background: inherit; overflow: hidden; } napp>.app-area,[data-is="napp"]>.app-area{ grid-area: app-area; position: relative; display: grid; grid-template-columns: auto 1fr; grid-template-rows: auto 1fr auto; grid-template-areas: \'navi-area navi-area\' \'sidebar-area scrn-area\' \'sidebar-area stat-area\'; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; } napp>.app-area>:not(sidebar):not(navibar):not(screen):not(statusbar),[data-is="napp"]>.app-area>:not(sidebar):not(navibar):not(screen):not(statusbar){ display: none; } napp>.app-area sidebar:nth-of-type(1),[data-is="napp"]>.app-area sidebar:nth-of-type(1){ grid-area: sidebar-area; position: relative; margin: 0; padding: 0; } napp>.app-area sidebar:not(:nth-of-type(1)),[data-is="napp"]>.app-area sidebar:not(:nth-of-type(1)){ grid-area: sidebar-area; display: none; margin: 0; padding: 0; } napp>.app-area navibar:nth-of-type(1),[data-is="napp"]>.app-area navibar:nth-of-type(1){ grid-area: navi-area; position: relative; margin: 0; padding: 0; } napp>.app-area navibar:not(:nth-of-type(1)),[data-is="napp"]>.app-area navibar:not(:nth-of-type(1)){ grid-area: navi-area; display: none; margin: 0; padding: 0; } napp>.app-area screen,[data-is="napp"]>.app-area screen{ grid-area: scrn-area; position: relative; margin: 0; padding: 0; } napp>.app-area statusbar:last-of-type(1),[data-is="napp"]>.app-area statusbar:last-of-type(1){ grid-area: stat-area; position: relative; margin: 0; padding: 0; } napp>.app-area statusbar:not(:last-of-type(1)),[data-is="napp"]>.app-area statusbar:not(:last-of-type(1)){ grid-area: stat-area; display: none; margin: 0; padding: 0; }', '', function(opts) {
});
riot.tag2('screen', '<div class="content-area"> <yield></yield> </div>', 'screen,[data-is="screen"]{ margin: 0 auto; padding: 0; display: none; width: 100%; height: 100%; } screen.active,[data-is="screen"].active,screen.show,[data-is="screen"].show{ display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'content-area\'; } screen .content-area,[data-is="screen"] .content-area{ grid-area: content-area; position: relative; margin: 0; padding: 0; width: 100%; height: 100%; overflow: hidden; }', '', function(opts) {
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            addEvt(events.name.ScreenChanged, onScreenChanged)
        })
        this.on('unmount', () => {
            delEvt(events.name.ScreenChanged, onScreenChanged)
        })

        let onScreenChanged = (e) => {
            (screens.is(self.opts.screenid)) ? self.show() : self.hide()
            self.update()
        }

        this.hide = () => { self.root.classList.remove('show') }
        this.show = () => { self.root.classList.add('show') }
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
riot.tag2('navibar', '<yield></yield>', 'navibar,[data-is="navibar"]{ position: relative; display: flex; align-items: baseline; justify-content: space-between; margin: 0; padding: 1px 4px; width: 100%; color: var(--navibar-foreground-color); background-color: var(--navibar-background-color); overflow: hidden; }', '', function(opts) {
});
riot.tag2('sidebar', '<div class="sidebar-container"> <yield></yield> </div>', 'sidebar,[data-is="sidebar"]{ position: relative; display: none; margin: 0; padding: 0; width: 300px; height: calc(100% - 2px); border: 1px solid black; z-index: 99999; overflow: hidden; } sidebar.show,[data-is="sidebar"].show,sidebar.active,[data-is="sidebar"].active{ display: inline-block; position: fixed; } @media only screen and (max-width: 700px) { sidebar.show,[data-is="sidebar"].show,sidebar.active,[data-is="sidebar"].active{ display: inline-block; position: absolute; } } sidebar .sidebar-container,[data-is="sidebar"] .sidebar-container{ position: absolute; margin: 0; padding: 0; width: 100%; height: 100%; overflow: auto; } sidebar.c1,[data-is="sidebar"].c1{ background-color: burlywood; } sidebar.c2,[data-is="sidebar"].c2{ background-color: aliceblue; } sidebar.c3,[data-is="sidebar"].c3{ background-color: cornsilk; }', '', function(opts) {
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {

            addEvt(events.name.SidebarStateChanged, onSidebarStateChanged)

            self.show();
        });
        this.on('unmount', () => {
            delEvt(events.name.SidebarStateChanged, onSidebarStateChanged)

        });

        let onSidebarStateChanged = () => {
            (sidebar.shown) ? self.show() : self.hide()
        }

        this.show = () => {
            console.log('show')
            self.root.classList.add('show')
        }
        this.hide = () => {
            console.log('hide')
            self.root.classList.remove('show')
        }
});
riot.tag2('statusbar', '<div class="statusbar-container"> <yield></yield> </div>', 'statusbar,[data-is="statusbar"]{ position: relative; display: block; margin: 0 auto; padding: 0; width: 100%; user-select: none; white-space: nowrap; overflow: hidden; } statusbar>.statusbar-container,[data-is="statusbar"]>.statusbar-container{ position: relative; display: block; margin: 0 auto; padding: 0; width: 100%; height: fit-content; }', '', function(opts) {
});
riot.tag2('language-menu', '<div class="menu"> <a ref="flags" class="flag-combo" href="javascript:;"> <span class="flag-css flag-icon flag-icon-{lang.current.flagId.toLowerCase()}" ref="css-icon"></span> <div class="flag-text">&nbsp;{lang.langId}&nbsp;</div> <virtual if="{isMultiple()}"> <span class="drop-synbol fas fa-caret-down"></span> </virtual> </a> </div> <div ref="dropItems" class="language-dropbox"> <div each="{item in lang.languages}"> <a class="flag-item {(lang.langId === item.langId) ? \'selected\' : \'\'}" href="javascript:;" onclick="{selectItem}"> &nbsp; <span class="flag-css flag-icon flag-icon-{item.flagId.toLowerCase()}" ref="css-icon"></span> &nbsp; <div class="flag-text">{item.Description}</div> &nbsp;&nbsp;&nbsp; </a> </div> </div>', 'language-menu,[data-is="language-menu"]{ margin: 0 auto; padding: 0, 2px; user-select: none; } language-menu .menu,[data-is="language-menu"] .menu{ margin: 0 auto; padding: 0; } language-menu a,[data-is="language-menu"] a{ margin: 0 auto; color: whitesmoke; } language-menu a:link,[data-is="language-menu"] a:link,language-menu a:visited,[data-is="language-menu"] a:visited{ text-decoration: none; } language-menu a:hover,[data-is="language-menu"] a:hover,language-menu a:active,[data-is="language-menu"] a:active{ color: yellow; text-decoration: none; } language-menu .flag-combo,[data-is="language-menu"] .flag-combo{ margin: 0 auto; } language-menu .flag-combo .flag-css,[data-is="language-menu"] .flag-combo .flag-css{ margin: 0px auto; padding-top: 1px; display: inline-block; } language-menu .flag-combo .flag-text,[data-is="language-menu"] .flag-combo .flag-text{ margin: 0 auto; display: inline-block; } language-menu .flag-combo .drop-symbol,[data-is="language-menu"] .flag-combo .drop-symbol{ margin: 0 auto; display: inline-block; } language-menu .flag-item,[data-is="language-menu"] .flag-item{ margin: 0px auto; padding: 2px; padding-left: 5px; height: 50px; display: flex; align-items: center; justify-content: center; } language-menu .flag-item:hover,[data-is="language-menu"] .flag-item:hover{ color: yellow; background:linear-gradient(to bottom, #0c5a24 5%, #35750a 100%); background-color:#77a809; cursor: pointer; } language-menu .flag-item.selected,[data-is="language-menu"] .flag-item.selected{ background-color: darkorange; } language-menu .flag-item .flag-css,[data-is="language-menu"] .flag-item .flag-css{ margin: 0px auto; padding-top: 1px; width: 25px; display: inline-block; } language-menu .flag-item .flag-text,[data-is="language-menu"] .flag-item .flag-text{ margin: 0 auto; min-width: 80px; max-width: 120px; display: inline-block; } language-menu .language-dropbox,[data-is="language-menu"] .language-dropbox{ display: inline-block; position: fixed; margin: 0 auto; padding: 1px; top: 45px; right: 5px; background-color: #333; color:whitesmoke; max-height: calc(100vh - 50px - 20px); overflow: hidden; overflow-y: auto; display: none; } language-menu .language-dropbox.show,[data-is="language-menu"] .language-dropbox.show{ display: inline-block; z-index: 99999; }', '', function(opts) {
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
            toggle();
            let selLang = e.item.item
            lang.change(selLang.langId)
            e.preventDefault()
            e.stopPropagation()
        }

});
riot.tag2('links-menu', '<div class="menu"> <a ref="links" class="link-combo" href="javascript:;"> <span ref="showlinks" class="burger fas fa-bars"></span> </a> </div> <div ref="dropItems" class="links-dropbox"> <div each="{item in menus}"> <virtual if="{isShown(item)}"> <a class="link-item" href="javascript:;" onclick="{selectItem}"> &nbsp; <span class="link-css {item.icon}" ref="css-icon">&nbsp;</span> <div class="link-text">&nbsp;{item.text}</div> &nbsp;&nbsp;&nbsp; </a> </virtual> </div> </div>', 'links-menu,[data-is="links-menu"]{ margin: 0 auto; padding: 0 3px; user-select: none; width: 40px; } links-menu.hide,[data-is="links-menu"].hide{ display: none; } links-menu .menu,[data-is="links-menu"] .menu{ margin: 0 auto; padding: 0; } links-menu a,[data-is="links-menu"] a{ margin: 0 auto; color: whitesmoke; } links-menu a:link,[data-is="links-menu"] a:link,links-menu a:visited,[data-is="links-menu"] a:visited{ text-decoration: none; } links-menu a:hover,[data-is="links-menu"] a:hover,links-menu a:active,[data-is="links-menu"] a:active{ color: yellow; text-decoration: none; } links-menu .link-combo,[data-is="links-menu"] .link-combo{ margin: 0 auto; } links-menu .link-item,[data-is="links-menu"] .link-item{ margin: 0px auto; padding: 2px; padding-left: 5px; height: 50px; display: flex; align-items: center; justify-content: center; } links-menu .link-item:hover,[data-is="links-menu"] .link-item:hover{ color: yellow; background:linear-gradient(to bottom, #0c5a24 5%, #35750a 100%); background-color:#77a809; cursor: pointer; } links-menu .link-item.selected,[data-is="links-menu"] .link-item.selected{ background-color: darkorange; } links-menu .link-item .link-css,[data-is="links-menu"] .link-item .link-css{ margin: 0px auto; width: 25px; display: inline-block; } links-menu .link-item .link-text,[data-is="links-menu"] .link-item .link-text{ margin: 0 auto; min-width: 80px; max-width: 125px; display: inline-block; } links-menu .links-dropbox,[data-is="links-menu"] .links-dropbox{ display: inline-block; position: fixed; margin: 0 auto; padding: 1px; top: 45px; right: 5px; background-color: #333; color:whitesmoke; max-height: calc(100vh - 50px - 20px); overflow: hidden; overflow-y: auto; display: none; } links-menu .links-dropbox.show,[data-is="links-menu"] .links-dropbox.show{ display: inline-block; z-index: 99999; }', 'class="{(menus && menus.length > 0) ? \'\' : \'hide\'}"', function(opts) {
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        });
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        });

        let links, dropItems
        let initCtrls = () => {
            links = self.refs['links']
            dropItems = self.refs['dropItems']
        }
        let freeCtrls = () => {
            dropItems = null
            links = null
        }
        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)

            links.addEventListener('click', toggle);
            window.addEventListener('click', checkClickPosition);
        }
        let unbindEvents = () => {
            window.removeEventListener('click', checkClickPosition);
            links.removeEventListener('click', toggle);

            delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }

        let onLanguageChanged = (e) =>  { updatecontent() }
        let onContentChanged = (e) => { updatecontent()  }
        let onScreenChanged = (e) =>  { updatecontent() }

        this.menus = []
        let updatecontent = () => {
            self.menus = (contents && contents.current) ? contents.current.links : []
            self.update();
        }

        let toggle = () => {
            dropItems.classList.toggle('show');
            updatecontent();
        }
        let isInClassList = (elem, classList) => {
            let len = classList.length;
            let found = false;
            for (let i = 0; i < len; i++) {
                if (elem.matches(classList[i])) {
                    found = true;
                    break;
                }
            }
            return found;
        }
        let checkClickPosition = (e) => {

            let classList = ['.link-combo', '.burger'];
            let match = isInClassList(e.target, classList);
            if (!match) {
                if (dropItems.classList.contains('show')) {
                    toggle();
                }
            }
        }

        this.isShown = (item) => {
            let ret = true;
            let linkType = (item.type) ? item.type.toLowerCase() : ''
            if (linkType === 'screen' || linkType === 'url') {

                ret = item.id !== screens.current.screenId
            }
            return ret
        }
        this.selectItem = (e) => {
            toggle()
            let selLink = e.item.item
            let linkType = (selLink.type) ? selLink.type.toLowerCase() : ''
            if (linkType === 'screen') {
                screens.show(selLink.id)
            }
            else if (linkType === 'url') {
                nlib.nav.gotoUrl(selLink.ref)
            }
            else if (linkType === 'cmd') {
                if (selLink.ref.toLowerCase() === 'signout') {
                    secure.signout()
                }
                else if (selLink.ref.toLowerCase() === 'exit') {
                    secure.changeCustomer()
                }
            }
            else {
                console.log('Not implements type, data:', selLink);
            }
            e.preventDefault();
            e.stopPropagation();
        }
});
riot.tag2('sidebar-menu', '<div class="menu"> <a class="link-combo" href="javascript:;" onclick="{toggle}"> <span class="burger fas fa-bars"></span> </a> </div>', 'sidebar-menu,[data-is="sidebar-menu"]{ display: inline-block; margin: 0 auto; padding: 0, 2px; user-select: none; } sidebar-menu .menu,[data-is="sidebar-menu"] .menu{ display: none; } @media only screen and (max-width: 700px) { sidebar-menu .menu,[data-is="sidebar-menu"] .menu{ display: inline-block; } } sidebar-menu .menu>a,[data-is="sidebar-menu"] .menu>a{ margin: 0 auto; color: whitesmoke; } sidebar-menu .menu>a:link,[data-is="sidebar-menu"] .menu>a:link,sidebar-menu .menu>a:visited,[data-is="sidebar-menu"] .menu>a:visited{ text-decoration: none; } sidebar-menu .menu>a:hover,[data-is="sidebar-menu"] .menu>a:hover,sidebar-menu .menu>a:active,[data-is="sidebar-menu"] .menu>a:active{ color: yellow; text-decoration: none; }', '', function(opts) {
        let self = this;
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {

        });
        this.on('unmount', () => {

        });

        this.toggle = (e) => {
            e.preventDefault()
            e.stopPropagation()
        }
});
riot.tag2('rater-device-app', '<napp> <yield></yield> </napp>', 'rater-device-app,[data-is="rater-device-app"]{ position: relative; display: block; margin: 0; padding: 0; width: auto; height: auto; overflow: hidden; }', '', function(opts) {
});
riot.tag2('rater-web-app', '<napp> <sidebar> <h6>Sidebar Left</h6> </sidebar> <navibar> <navi-item><sidebar-menu></sidebar-menu></navi-item> <navi-item> <div class="banner"> <div class="caption">My Choice Rater Web{(content && content.title) ? \'&nbsp;-&nbsp;\' : \'&nbsp;\'}</div> <div class="title ">{(content && content.title) ? content.title : \'\'}</div> </div> </navi-item> <navi-item class="center"></navi-item> <navi-item class="right"><language-menu></language-menu></navi-item> <navi-item class="right"><links-menu></links-menu></navi-item> </navibar> <yield></yield> <statusbar> <span class="copyright">EDL Co., Ltd.</span> </statusbar> </napp>', 'rater-web-app,[data-is="rater-web-app"]{ position: relative; display: block; margin: 0; padding: 0; width: auto; height: auto; overflow: hidden; } rater-web-app .banner .title,[data-is="rater-web-app"] .banner .title{ margin: 0; padding: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 1.2rem; } rater-web-app .banner .caption,[data-is="rater-web-app"] .banner .caption{ margin: 0; padding: 0; width: auto; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-size: 1.2rem; } @media only screen and (max-width: 700px) { rater-web-app .banner .caption,[data-is="rater-web-app"] .banner .caption{ width: 0; visibility: hidden; } } rater-web-app language-menu,[data-is="rater-web-app"] language-menu{ display: flex; margin: 0 auto; padding: 0; align-items: center; justify-content: stretch; } rater-web-app links-menu,[data-is="rater-web-app"] links-menu{ display: flex; margin: 0 auto; padding: 0; align-items: center; justify-content: stretch; } rater-web-app .copyright,[data-is="rater-web-app"] .copyright{ margin: 0; padding: 0; font-size: .5em; color: black; }', '', function(opts) {


        let self = this;
        this.content = {
            title: ''
        }
        this.hasContent = () => { return (this.content !== undefined && this.content != null) }

        let updatecontent = () => {

            self.update()
        }

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
        })

        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)

            addEvt(events.name.ScreenChanged, onScreenChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ScreenChanged, onScreenChanged)

            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }

        let onContentChanged = (e) => { updatecontent() }
        let onLanguageChanged = (e) => { updatecontent() }
        let onScreenChanged = (e) => { updatecontent() }
});
riot.tag2('admin-home', '<div class="client-area"> <div class="info-panel"> <div class="info-box"> <div class="info-data"> <div class="info-data-value">3.82</div> </div> <div class="info-caption"> <div class="info-caption-icon"> <span class="fas fa-calendar"></span> </div> <div class="info-caption-text"> Average </div> </div> </div> <div class="info-box"> <div class="info-data"> <div class="info-data-value">87%</div> </div> <div class="info-caption"> <div class="info-caption-icon"> <span class="fas fa-calendar"></span> </div> <div class="info-caption-text"> Average % </div> </div> </div> <div class="info-box"> <div class="info-data"> <div class="info-data-value">200 K+</div> </div> <div class="info-caption"> <div class="info-caption-icon"> <span class="fas fa-calendar"></span> </div> <div class="info-caption-text"> Total Votes </div> </div> </div> <div class="info-box"> <div class="info-data"> <div class="info-data-value">30</div> </div> <div class="info-caption"> <div class="info-caption-icon"> <span class="fas fa-calendar"></span> </div> <div class="info-caption-text"> Wait list </div> </div> </div> </div> <div class="chart-panel"> <div class="bar-chart"> <div class="chart-box" ref="bar1"></div> </div> <div class="pie-chart"> <div class="chart-box" ref="pie1"></div> </div> </div> </div>', 'admin-home,[data-is="admin-home"]{ display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'client-area\'; margin: 0 auto; padding: 0; width: 100%; height: 100%; } admin-home>.client-area,[data-is="admin-home"]>.client-area{ grid-area: client-area; display: grid; grid-auto-flow: row; grid-auto-rows: max-content; grid-gap: 10px; margin: 0; padding: 5px; width: 100%; height: 100%; border: 1px dotted navy; overflow: auto; } admin-home>.client-area .chart-panel,[data-is="admin-home"]>.client-area .chart-panel{ display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); grid-gap: 10px; grid-auto-rows: minmax(200px, max-content); margin: 0; padding: 5px; width: 100%; height: auto; } admin-home>.client-area .bar-chart,[data-is="admin-home"]>.client-area .bar-chart{ position: relative; display: block; margin: 0; padding: 5px; width: 100%; height: 100%; background: whitesmoke; border: 1px dotted orchid; border-radius: 5px; box-shadow: 5px 5px 8px -3px rgba(0, 0, 0, 0.4); } admin-home>.client-area .bar-chart .chart-box,[data-is="admin-home"]>.client-area .bar-chart .chart-box{ display: block; position: absolute; margin: 0; padding: 5px; width: 100%; height: 100%; min-width: 100px; } admin-home .bar-chart .chart-box .highcharts-background,[data-is="admin-home"] .bar-chart .chart-box .highcharts-background{ fill: rgba(250, 250, 250, .1); } admin-home>.client-area .pie-chart,[data-is="admin-home"]>.client-area .pie-chart{ position: relative; display: block; margin: 0; padding: 5px; width: 100%; height: 100%; background: whitesmoke; border: 1px dotted skyblue; border-radius: 5px; box-shadow: 5px 5px 8px -3px rgba(0, 0, 0, 0.4); } admin-home>.client-area .pie-chart .chart-box,[data-is="admin-home"]>.client-area .pie-chart .chart-box{ display: block; margin: 0 auto; padding: 5px; width: 100%; height: 100%; } admin-home>.client-area .pie-chart .chart-box .highcharts-background,[data-is="admin-home"]>.client-area .pie-chart .chart-box .highcharts-background{ fill: rgba(250, 250, 250, .1); } admin-home>.client-area .info-panel,[data-is="admin-home"]>.client-area .info-panel{ display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); grid-gap: 10px; grid-auto-rows: max-content; margin: 0; padding: 5px; width: 100%; height: auto; } admin-home>.client-area .info-box,[data-is="admin-home"]>.client-area .info-box{ display: inline-block; margin: 0; padding: 5px; height: fit-content; font-size: 1rem; background: wheat; border: 1px dotted chocolate; border-radius: 5px; box-shadow: 5px 5px 8px -3px rgba(0, 0, 0, 0.4); } @media only screen and (min-width: 400px) { admin-home>.client-area .info-box,[data-is="admin-home"]>.client-area .info-box{ background: olive; } } @media only screen and (min-width: 600px) { admin-home>.client-area .info-box,[data-is="admin-home"]>.client-area .info-box{ background: hotpink; } } @media only screen and (min-width: 800px) { admin-home>.client-area .info-box,[data-is="admin-home"]>.client-area .info-box{ background: fuchsia; } } @media only screen and (min-width: 1000px) { admin-home>.client-area .info-box,[data-is="admin-home"]>.client-area .info-box{ background: grey; } } admin-home>.client-area .info-box .info-data-value,[data-is="admin-home"]>.client-area .info-box .info-data-value{ display: inline-block; margin: 0 auto; padding: 0; width: 100%; height: auto; font-size: 2.5em; font-weight: bold; text-align: center; } admin-home>.client-area .info-box .info-caption,[data-is="admin-home"]>.client-area .info-box .info-caption{ display: inline-block; margin: 0 auto; padding: 0; width: 100%; height: auto; text-align: center; } admin-home>.client-area .info-box .info-caption-icon,[data-is="admin-home"]>.client-area .info-box .info-caption-icon{ display: inline-block; margin: 0; padding: 0; height: auto; font-size: 0.7em; font-weight: normal; } admin-home>.client-area .info-box .info-caption-text,[data-is="admin-home"]>.client-area .info-box .info-caption-text{ display: inline-block; margin: 0; padding: 0; height: auto; font-size: 0.7em; font-weight: normal; }', '', function(opts) {
        let self = this
        let screenId = 'admin-home'
        let defaultContent = {
            title: 'Admin Home Page.'
        }
        this.content = defaultContent;

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })
        let bar1, pie1
        let initCtrls = () => {
            bar1 = self.refs['bar1']
            pie1 = self.refs['pie1']
        }
        let freeCtrls = () => {
            pie1 = null
            bar1 = null
        }
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
        let onContentChanged = (e) => { updatecontent() }
        let onLanguageChanged = (e) => { updatecontent() }
        let onScreenChanged = (e) => { updatecontent() }
        let updatecontent = () => {
            if (screens.is(screenId)) {
                let scrContent = contents.getScreenContent()
                self.content = scrContent ? scrContent : defaultContent
                updateBar()
                updatePie()
                self.update()
            }
        }

        let data1 = [
            { name: 'EDL', y: 3.5 },
            { name: 'Sale', y: 3.8 },
            { name: 'Engineer', y: 3.2 },
            { name: 'Supports', y: 2.9 },
            { name: 'Finance', y: 3.7 }
        ];
        let xlabels = [
            'EDL',
            'Sale',
            'Engineer',
            'Supports',
            'Finance'
        ];

        let chartTitle = 'EDL';
        let data2 = [
            { name: 'Excellent', y: 30 },
            { name: 'Good', y: 21 },
            { name: 'Fair', y: 24 },
            { name: 'Poor', y: 15 }
        ];

        let updateBar = () => {
            Highcharts.chart(bar1, {
                credits: {
                    enabled: false
                },
                chart: {
                    type: 'column'
                },
                title: {
                    text: 'Vote Summary Bar graph'
                },
                subtitle: {

                },
                xAxis: {

                    categories: xlabels
                },
                yAxis: {
                    title: { text: 'Average' }
                },
                legend: { enabled: false },
                plotOptions: {
                    series: {
                        borderWidth: 0,
                        dataLabels: {
                            enabled: true,
                            format: '{point.y:.2f}'
                        }
                    }
                },
                tooltip: {

                    headerFormat: '',

                    pointFormat: '<span>{point.name}</span>: <b>{point.y:.2f}</b><br/>'
                },
                series: [{
                    name: "Organization",
                    colorByPoint: true,
                    data: data1
                }]
            });
        }

        let updatePie = () => {
            Highcharts.chart(pie1, {
                credits: {
                    enabled: false
                },
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: chartTitle
                },
                tooltip: {
                    pointFormat: '<b>{point.percentage:.2f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: false,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: true,
                            format: '<b>{point.name}</b>: {point.percentage:.2f} %'
                        }
                    }
                },
                series: [{
                    name: 'Choice',
                    colorByPoint: true,
                    data: data2
                }]
            });
        }
});
riot.tag2('member-editor', '<div class="entry"> <tabcontrol class="tabs" content="{opts.content}"> <tabheaders content="{opts.content}"> <tabheader for="default" content="{opts.content}"> <span class="fas fa-cog"></span> {opts.content.entry.tabDefault} </tabheader> <tabheader for="miltilang" content="{opts.content}"> <span class="fas fa-globe-americas"></span> {opts.content.entry.tabMultiLang} </tabheader> </tabheaders> <tabpages> <tabpage name="default"> <div class="scrollable"> <member-entry ref="EN" langid=""></member-entry> </div> </tabpage> <tabpage name="miltilang"> <div class="scrollable"> <virtual if="{lang.languages}"> <virtual each="{item in lang.languages}"> <virtual if="{item.langId !==\'EN\'}"> <div class="panel-header" langid="{item.langId}"> &nbsp;&nbsp; <span class="flag-css flag-icon flag-icon-{item.flagId.toLowerCase()}"></span> &nbsp;{item.Description}&nbsp; </div> <div class="panel-body" langid="{item.langId}"> <member-entry ref="{item.langId}" langid="{item.langId}"></member-entry> </div> </virtual> </virtual> </virtual> </div> </tabpage> </tabpages> </tabcontrol> <div class="tool"> <button class="float-button save" onclick="{save}"><span class="fas fa-save"></span></button> <button class="float-button cancel" onclick="{cancel}"><span class="fas fa-times"></span></button> </div> </div>', 'member-editor,[data-is="member-editor"]{ margin: 0 auto; padding: 0; width: 100%; max-width: 800px; height: 100%; display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'entry\'; background-color: white; overflow: hidden; } member-editor>.entry,[data-is="member-editor"]>.entry{ grid-area: entry; position: relative; display: grid; grid-template-columns: 1fr auto 5px; grid-template-rows: 1fr; grid-template-areas: \'tabs tool .\'; margin: 0 auto; padding: 0; padding-top: 20px; padding-bottom: 20px; width: 100%; height: 100%; overflow: auto; } member-editor>.entry .tabs,[data-is="member-editor"]>.entry .tabs{ grid-area: tabs; margin: 0 auto; padding: 0; width: 100%; height: 100%; overflow: hidden; } member-editor .scrollable,[data-is="member-editor"] .scrollable{ position: absolute; margin: 0 auto; padding: 0; width: 100%; height: 100%; overflow: auto; } member-editor>.entry .tool,[data-is="member-editor"]>.entry .tool{ grid-area: tool; display: grid; grid-template-columns: 1fr auto; grid-template-rows: auto 1fr auto; grid-template-areas: \'. .\' \'btn-cancel .\' \'btn-save .\'; margin: 0 auto; margin-left: 3px; padding: 0; width: 100%; height: 100%; overflow: hidden; } member-editor>.entry .tool .float-button,[data-is="member-editor"]>.entry .tool .float-button{ margin: 0 auto; padding: 0; border: none; outline: none; border-radius: 50%; height: 40px; width: 40px; color: whitesmoke; background: silver; cursor: pointer; } member-editor>.entry .tool .float-button:hover,[data-is="member-editor"]>.entry .tool .float-button:hover{ color: whitesmoke; background: forestgreen; } member-editor>.entry .tool .float-button.save,[data-is="member-editor"]>.entry .tool .float-button.save{ grid-area: btn-save; } member-editor>.entry .tool .float-button.cancel,[data-is="member-editor"]>.entry .tool .float-button.cancel{ grid-area: btn-cancel; } member-editor .panel-header,[data-is="member-editor"] .panel-header{ margin: 0 auto; padding: 0; padding-top: 3px; width: 100%; height: 30px; color: white; background: cornflowerblue; border-radius: 5px 5px 0 0; } member-editor .panel-body,[data-is="member-editor"] .panel-body{ margin: 0 auto; margin-bottom: 5px; padding: 2px; width: 100%; border: 1px solid cornflowerblue; }', '', function(opts) {
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
});
riot.tag2('member-entry', '<div class="padtop"></div> <div class="padtop"></div> <ninput ref="prefix" title="{content.entry.prefix}" type="text" name="prefix"></ninput> <ninput ref="firstName" title="{content.entry.firstName}" type="text" name="firstName"></ninput> <ninput ref="lastName" title="{content.entry.lastName}" type="text" name="lastName"></ninput> <virtual if="{isDefault()}"> <ninput ref="userName" title="{content.entry.userName}" type="text" name="userName"></ninput> <ninput ref="passWord" title="{content.entry.passWord}" type="password" name="passWord"></ninput> <nselect ref="memberTypes" title="{content.entry.memberType}"></nselect> </virtual>', 'member-entry,[data-is="member-entry"]{ margin: 0; padding: 0; width: 100%; height: 100%; } member-entry .padtop,[data-is="member-entry"] .padtop{ display: block; margin: 0 auto; width: 100%; min-height: 10px; }', '', function(opts) {
        let self = this
        let screenId = 'member-entry'
        this.isDefault = () => { return (opts.langid === '' || opts.langid === 'EN') }

        let defaultContent = {
            title: 'Member Edit',
            entry: {
                prefix: 'Prefix Name',
                firstName: 'First Name',
                lastName: 'Last Name',
                userName: 'User Name',
                passWord: 'Password',
                memberType: 'Member Type',
                tagId: 'Tag ID',
                idCard: 'ID Card',
                employeeCode: 'Employee Code',
            }
        }
        this.content = defaultContent;

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })
        let prefix, firstName, lastName, userName, passWord;

        let memberTypes;

        let initCtrls = () => {
            prefix = self.refs['prefix'];
            firstName = self.refs['firstName'];
            lastName = self.refs['lastName'];
            userName = self.refs['userName'];
            passWord = self.refs['passWord'];
            memberTypes = self.refs['memberTypes'];

        }
        let freeCtrls = () => {
            prefix = null;
            firstName = null;
            lastName = null;
            userName = null;
            passWord = null;
            memberTypes = null;

        }
        let clearInputs = () => {
            prefix.clear()
            firstName.clear()
            lastName.clear()
            userName.clear()
            passWord.clear()

            if (memberTypes) memberTypes.clear();

        }
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
                self.update();
            }
        }
});
riot.tag2('member-view', '<div ref="container" class="scrarea"> <div ref="tool" class="toolarea"> <button class="float-button" onclick="{addnew}"> <span class="fas fa-plus">&nbsp;</span> </button> <button class="float-button" onclick="{refresh}"> <span class="fas fa-sync">&nbsp;</span> </button> </div> <div ref="grid" class="gridarea"></div> </div>', 'member-view,[data-is="member-view"]{ margin: 0 auto; padding: 0; width: 100%; height: 100%; display: grid; grid-template-columns: 1fr; grid-template-rows: 20px 1fr 20px; grid-template-areas: \'.\' \'scrarea\' \'.\' } member-view>.scrarea,[data-is="member-view"]>.scrarea{ grid-area: scrarea; position: relative; display: grid; grid-template-columns: 5px auto 1fr; grid-template-rows: 1fr; grid-template-areas: \'. toolarea gridarea\'; margin: 0 auto; padding: 0; margin-top: 3px; width: 100%; max-width: 800px; height: 100%; } member-view>.scrarea>.toolarea,[data-is="member-view"]>.scrarea>.toolarea{ grid-area: toolarea; margin: 0 auto; margin-right: 5px; padding: 0; height: 100%; overflow: hidden; background-color: transparent; color: whitesmoke; } member-view>.scrarea>.toolarea .float-button,[data-is="member-view"]>.scrarea>.toolarea .float-button{ display: block; margin: 0 auto; margin-bottom: 5px; padding: 3px; padding-right: 1px; height: 40px; width: 40px; color: whitesmoke; background: silver; border: none; outline: none; border-radius: 50%; cursor: pointer; } member-view>.scrarea>.toolarea .float-button:hover,[data-is="member-view"]>.scrarea>.toolarea .float-button:hover{ color: whitesmoke; background: forestgreen; } member-view>.scrarea>.gridarea,[data-is="member-view"]>.scrarea>.gridarea{ position: absolute; grid-area: gridarea; margin: 0 auto; padding: 0; height: 100%; width: 100%; } member-view .tabulator-row button,[data-is="member-view"] .tabulator-row button{ margin: 0 auto; padding: 0px; width: 100%; font-size: small; color: inherit; background: transparent; border: none; outline: none; cursor: pointer; } member-view .tabulator-row button:hover,[data-is="member-view"] .tabulator-row button:hover{ color: forestgreen; } member-view .tabulator-row button>span,[data-is="member-view"] .tabulator-row button>span{ margin: 0 auto; padding: 0; }', '', function(opts) {
        let self = this;
        let screenId = 'member-view'
        let defaultContent = {
            title: 'Member Management',
            columns: []
        }
        this.content = defaultContent

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })
        let initCtrls = () => { initGrid() }
        let freeCtrls = () => { table = null }

        let table
        let initGrid = (data) => {
            let opts = {
                height: "100%",
                layout: "fitDataFill",
                data: (data) ? data : []
            }
            setupColumns(opts)
            table = new Tabulator(self.refs['grid'], opts)
        }
        let setupColumns = (opts) => {
            let = columns = [
                { formatter: editIcon, align:"center", width: 44,
                    resizable: false, frozen: true, headerSort: false,
                    cellClick: editRow
                },
                { formatter: deleteIcon, align:"center", width: 44,
                    resizable: false, frozen: true, headerSort: false,
                    cellClick: deleteRow
                }
            ]
            if (self.content && self.content.columns) {
                let cols = self.content.columns
                columns.push(...cols)
            }
            opts.columns = columns
        }
        let datasource
        let syncData = () => {
            if (table) table = null
            let data = (datasource && datasource[lang.langId]) ? datasource[lang.langId] : null
            initGrid(data)
        }
        let editIcon = (cell, formatterParams) => {
            return "<button><span class='fas fa-edit'></span></button>"
        };
        let deleteIcon = (cell, formatterParams) => {
            return "<button><span class='fas fa-trash-alt'></span></button>"
        };

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
        let onLanguageChanged = (e) => {
            if (screens.is(screenId)) {
                updatecontent();
                syncData();
            }
        }
        let onScreenChanged = (e) => {
            if (screens.is(screenId)) {
                updatecontent();
                self.refresh();
            }
        }
        let onMemberListChanged = (e) => {

        }

        let editRow = (e, cell) => {

        }
        let deleteRow = (e, cell) => {

        }
        let onEndEdit = (e) => {

        }

        let updatecontent = () => {
            if (screens.is(screenId)) {
                let scrContent = contents.getScreenContent()
                self.content = scrContent ? scrContent : defaultContent
                self.update()
                if (table) table.redraw(true)
            }
        }
        this.addnew = (e) => {

        }
        this.refresh = (e) => {
            let url = '/customer/api/member'
            let paramObj = {
                langId: lang.langId
            }
            let fn = (r) => {
                let ret = api.parse(r)
                datasource = ret.records
                syncData()
                updatecontent()
            }
            XHR.get(url, paramObj, fn)
        }
});
riot.tag2('rater-home', '<div class="content-area"> <div class="padtop"></div> <div class="padtop"></div> <div class="padtop"></div> <div class="padtop"></div> <div class="padtop"></div> <div class="padtop"></div> <div ref="userSignIn" class="user-signin"> <div class="group-header"> <h4><span class="fa fa-user-lock">&nbsp;</span>&nbsp;{content.title}</h4> <div class="padtop"></div> </div> <div class="group-body"> <div class="padtop"></div> <ninput ref="userName" title="{content.label.userName}" type="text" name="userName"></ninput> <ninput ref="passWord" title="{content.label.passWord}" type="password" name="pwd"></ninput> <div class="padtop"></div> <button ref="submit"> <span class="fas fa-user">&nbsp;</span> {content.label.submit} </button> <div class="padtop"></div> <div class="padtop"></div> </div> </div> <div ref="userSelection" class="user-selection hide"> <div class="group-header"> <h4>{content.label.selectAccount}</h4> <div class="padtop"></div> </div> <div class="group-body"> <div class="padtop"></div> <div class="padtop"></div> <company-selection ref="userList" companyname="{content.label.companyName}" fullname="{content.label.fullName}"> </company-selection> <div class="padtop"></div> <button ref="cancel"> <span class="fa fa-user-times">&nbsp;</span> Cancel </button> <div class="padtop"></div> <div class="padtop"></div> </div> </div> </div>', 'rater-home,[data-is="rater-home"]{ margin: 0 auto; padding: 2px; position: relative; width: 100%; height: 100%; display: grid; grid-template-columns: 1fr; grid-template-rows: 1fr; grid-template-areas: \'content-area\'; overflow: hidden; } rater-home .content-area,[data-is="rater-home"] .content-area{ grid-area: content-area; margin: 0 auto; padding: 0px; position: relative; display: block; width: 100%; height: 100%; background-color: white; background-image: url(\'public/assets/images/backgrounds/bg-15.jpg\'); background-blend-mode: multiply, luminosity; background-position: center; background-repeat: no-repeat; background-size: cover; } rater-home .content-area .user-signin,[data-is="rater-home"] .content-area .user-signin,rater-home .content-area .user-selection,[data-is="rater-home"] .content-area .user-selection{ display: block; position: relative; margin: 0 auto; padding: 0; } rater-home .content-area .user-signin.hide,[data-is="rater-home"] .content-area .user-signin.hide,rater-home .content-area .user-selection.hide,[data-is="rater-home"] .content-area .user-selection.hide{ display: none; } rater-home .padtop,[data-is="rater-home"] .padtop,rater-home .content-area .padtop,[data-is="rater-home"] .content-area .padtop,rater-home .content-area .user-signin .group-header .padtop,[data-is="rater-home"] .content-area .user-signin .group-header .padtop,rater-home .content-area .user-signin .group-body .padtop,[data-is="rater-home"] .content-area .user-signin .group-body .padtop,rater-home .content-area .user-selection .group-header .padtop,[data-is="rater-home"] .content-area .user-selection .group-header .padtop,rater-home .content-area .user-selection .group-body .padtop,[data-is="rater-home"] .content-area .user-selection .group-body .padtop{ display: block; margin: 0 auto; width: 100%; min-height: 10px; } rater-home .content-area .user-signin .group-header,[data-is="rater-home"] .content-area .user-signin .group-header,rater-home .content-area .user-selection .group-header,[data-is="rater-home"] .content-area .user-selection .group-header{ display: block; margin: 0 auto; padding: 3px; width: 30%; min-width: 300px; max-width: 500px; opacity: 0.8; background-color: cornflowerblue; border: 1px solid dimgray; border-radius: 8px 8px 0 0; } rater-home .content-area .user-signin .group-header h4,[data-is="rater-home"] .content-area .user-signin .group-header h4,rater-home .content-area .user-selection .group-header h4,[data-is="rater-home"] .content-area .user-selection .group-header h4{ display: block; margin: 0 auto; padding: 0; padding-top: 5px; font-size: 1.1rem; text-align: center; color: whitesmoke; user-select: none; } rater-home .content-area .user-signin .group-body,[data-is="rater-home"] .content-area .user-signin .group-body,rater-home .content-area .user-selection .group-body,[data-is="rater-home"] .content-area .user-selection .group-body{ display: flex; flex-direction: column; align-items: center; margin: 0 auto; padding: 0; height: auto; width: 30%; min-width: 300px; max-width: 500px; opacity: 0.8; background-color: white; border: 1px solid dimgray; border-radius: 0 0 8px 8px; } rater-home .content-area .user-signin .group-body ninput,[data-is="rater-home"] .content-area .user-signin .group-body ninput,rater-home .content-area .user-selection .group-body ninput,[data-is="rater-home"] .content-area .user-selection .group-body ninput{ background-color: white; } rater-home .content-area .user-signin .group-body button,[data-is="rater-home"] .content-area .user-signin .group-body button,rater-home .content-area .user-selection .group-body button,[data-is="rater-home"] .content-area .user-selection .group-body button{ display: inline-block; margin: 5px auto; padding: 10px 15px; color: forestgreen; font-weight: bold; cursor: pointer; width: 45%; text-decoration: none; vertical-align: middle; }', '', function(opts) {
        let self = this;
        let defaultContent = {
            title: 'Sign In',
            label: {
                selectAccount: 'Please Select Account',
                userName: 'User Name (admin)',
                passWord: 'Password',
                submit: 'Sign In',
                companyName: 'Company Name',
                fullName: 'Account Name'
            }
        }
        this.content = defaultContent

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let userSignIn, userSelection
        let userName, passWord, submit, cancel

        let initCtrls = () => {
            userSignIn = self.refs['userSignIn']
            userSelection = self.refs['userSelection']
            userName = self.refs['userName']
            passWord = self.refs['passWord']
            submit = self.refs['submit']
            cancel = self.refs['cancel']
        }
        let freeCtrls = () => {
            userName = null
            passWord = null
            submit = null
            cancel = null
            userSignIn = null
            userSelection = null
        }
        let clearInputs = () => {
            if (userName && passWord) {
                userName.clear()
                passWord.clear()
            }
            secure.reset()
        }
        let checkUserName = () => {
            let ret = false
            let val = userName.value()
            ret = (val && val.length > 0)
            if (!ret) userName.focus()
            return ret
        }
        let checkPassword = () => {
            let ret = false
            let val = passWord.value()
            ret = (val && val.length > 0)
            if (!ret) passWord.focus()
            return ret
        }

        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)

            addEvt(events.name.UserListChanged, onUserListChanged)
            addEvt(events.name.UserSignInFailed, onSignInFailed)

            submit.addEventListener('click', onSubmit)
            cancel.addEventListener('click', onCancel)
        }
        let unbindEvents = () => {
            cancel.removeEventListener('click', onCancel)
            submit.removeEventListener('click', onSubmit)

            delEvt(events.name.UserListChanged, onUserListChanged)
            delEvt(events.name.UserSignInFailed, onSignInFailed)

            delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onContentChanged = (e) => { updatecontent() }
        let onLanguageChanged = (e) => { updatecontent() }
        let onScreenChanged = (e) => { updatecontent() }
        let onUserListChanged = (e) => { showUserSelection() }
        let onSignInFailed = (e) => {
            let err = e.detail.error

            console.log(err)
        }
        let onSubmit = (e) => {
            if (checkUserName() && checkPassword()) {

                let data = {
                    userName: userName.value(),
                    passWord: passWord.value()
                }
                secure.verifyUsers(data.userName, data.passWord)
            }
        }
        let onCancel = (e) => { showUserSignIn() }
        let showUserSignIn = () => {
            if (userSignIn && userSelection) {
                userSignIn.classList.remove('hide')
                userSelection.classList.add('hide')
                userName.focus()
            }
        }
        let showUserSelection = () => {
            if (userSignIn && userSelection) {
                console.log(secure.users)
                if (secure.users.length > 1) {

                    userSignIn.classList.add('hide')
                    userSelection.classList.remove('hide')
                }
                else if (secure.users.length === 1) {

                    let customerId = secure.users[0].customerId
                    secure.signin(customerId)
                }
                else {

                    console.log({ msg: 'No user found!!!.'})
                }
            }
        }
        let updatecontent = () => {
            let scrId = screens.current.screenId
            let scrContent = (contents.current && contents.current.screens) ? contents.current.screens[scrId] : null
            self.content = scrContent ? scrContent : defaultContent
            self.update()
        }
});
riot.tag2('company-selection', '<virtual each="{user in users}"> <div class="account"> <div class="info1"> <span class="label">{opts.companyname}</span> <span class="data">{user.CustomerName}</span> </div> <div class="info2"> <span class="label">{opts.fullname}</span> <span class="data">{user.FullName}</span> </div> <button onclick="{onSignIn}">&nbsp;<span class="fas fa-2x fa-sign-in-alt">&nbsp;</span></button> </div> <hr> </virtual>', 'company-selection,[data-is="company-selection"]{ display: block; margin: 0 auto; padding: 0; } company-selection .account,[data-is="company-selection"] .account{ margin: 0 auto; padding: 2px; height: 100%; width: 100%; display: grid; grid-template-columns: 1fr 1fr; grid-template-rows: 1fr 1fr; grid-template-areas: \'info1 button\' \'info2 button\'; overflow: hidden; overflow-y: auto; } company-selection .account div,[data-is="company-selection"] .account div{ display: block; margin: 0 auto; padding: 0; } company-selection .account div.info1,[data-is="company-selection"] .account div.info1{ grid-area: info1; display: block; margin: 0; padding: 0; padding-left: 20px; } company-selection .account div.info2,[data-is="company-selection"] .account div.info2{ grid-area: info2; display: block; margin: 0; padding: 0; padding-left: 20px; } company-selection .account div.info1 span,[data-is="company-selection"] .account div.info1 span,company-selection .account div.info2 span,[data-is="company-selection"] .account div.info2 span{ display: inline-block; margin: 0; padding: 0; } company-selection .account div.info1 span.label,[data-is="company-selection"] .account div.info1 span.label,company-selection .account div.info2 span.label,[data-is="company-selection"] .account div.info2 span.label{ display: inline-block; margin: 0 auto; padding: 0; font-weight: bold; color: navy; width: 100%; } company-selection .account div.info1 span.data,[data-is="company-selection"] .account div.info1 span.data,company-selection .account div.info2 span.data,[data-is="company-selection"] .account div.info2 span.data{ display: inline-block; margin: 0 auto; padding: 0; font-weight: bold; color: forestgreen; width: 100%; } company-selection .account button,[data-is="company-selection"] .account button{ grid-area: button; display: inline-block; margin: 0 auto; padding: 0; font-weight: bold; color: forestgreen; width: 100%; }', '', function(opts) {
        let self = this
        this.users = []

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
        });
        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.UserListChanged, onUserListChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.UserListChanged, onUserListChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onContentChanged = (e) => { updatecontent() }
        let onLanguageChanged = (e) => { updatecontent() }
        let onUserListChanged = (e) => { updatecontent() }

        let updatecontent = () => {
            if (secure) {

                self.users = (secure.content) ? secure.users : []
                self.update()
            }
        }

        this.onSignIn = (e) => {
            let acc = e.item.user
            secure.signin(acc.customerId)
        }
});
riot.tag2('register-entry', '', 'register-entry,[data-is="register-entry"]{ margin: 0 auto; }', '', function(opts) {


        this.on('mount', () => { });
        this.on('unmount', () => { });

});
riot.tag2('signin-entry', '', 'signin-entry,[data-is="signin-entry"]{ margin: 0 auto; }', '', function(opts) {


        this.on('mount', () => { });
        this.on('unmount', () => { });

});
riot.tag2('dualscreen1', '<dual-layout ref="layout"> <yield to="left-panel"> <left-screen ref="leftpanel" class="view"></left-screen> </yield> <yield to="right-panel"> <right-screen ref="rightpanel" class="entry"></right-screen> </yield> </dual-layout>', 'dualscreen1,[data-is="dualscreen1"]{ margin: 0; padding: 0; }', '', function(opts) {
        let self = this;

        let layout;
        this.on('mount', () => {
            layout = self.refs['layout']
        })
        this.on('unmount', () => {
            layout = null
        })

        this.toggle = () => {

            layout.toggle()
        }
});
riot.tag2('left-screen', '<h2>Left Screen</h2> <div class="fake-content"></div> <p>Middle of Content.</p> <button onclick="{toggle}">Toggle</button> <div class="fake-content"></div> <p>End of Content.</p>', 'left-screen,[data-is="left-screen"]{ position: relative; display: block; margin: 0; padding: 0; width: 100%; height: 100%; border: 1px solid silver; background-color: beige; overflow: auto; } left-screen .fake-content,[data-is="left-screen"] .fake-content{ height: 300px; }', '', function(opts) {
        let self = this;

        this.toggle = () => {
            self.parent.toggle()
        }
});
riot.tag2('right-screen', '<h2>Right Screen</h2> <div class="fake-content"></div> <p>Middle of Content.</p> <button onclick="{toggle}">Toggle</button> <div class="fake-content"></div> <p>End of Content.</p>', 'right-screen,[data-is="right-screen"]{ position: relative; display: block; margin: 0; padding: 0; width: 100%; height: 100%; border: 1px solid silver; background-color: seashell; overflow: auto; } right-screen .fake-content,[data-is="right-screen"] .fake-content{ height: 300px; }', '', function(opts) {
        let self = this;

        this.toggle = () => {
            self.parent.toggle()
        }
});
riot.tag2('screen1', '<h4>Screen 1</h4> <button onclick="{gotoScreen2}">Goto Screen 2</button>', 'screen1,[data-is="screen1"]{ margin: 0 auto; padding: 0; width: 100%; height: 100%; }', '', function(opts) {
        let self = this
        let scrId = 'screen1'

        this.gotoScreen2 = (e) => { screens.show('screen2') }
});

riot.tag2('screen2', '<h3>Screen 2</h3> <button onclick="{gotoScreen1}">Goto Screen 1</button>', 'screen2,[data-is="screen2"]{ margin: 0 auto; padding: 0; width: 100%; height: 100%; }', '', function(opts) {
        let self = this
        let scrId = 'screen2'

        this.gotoScreen1 = (e) => { screens.show('screen1') }
});
