//#region EventService class

class EventService {
    constructor() {
        this.name = {}
    }
    raise(eventName, data) {
        // Raise event.
        let evt;
        if (data) {
            evt = new CustomEvent(eventName, { detail: { data: data } });
        }
        else {
            evt = new CustomEvent(eventName);
        }
        document.dispatchEvent(evt);
    }
}

//console.log('Init event service...');
window.events = window.events || new EventService();
/** 
 * The Document event helper class.
 */
window.events.doc = class {
    /**
     * Add document event listener.
     * @param {String} evtName The Event Name.
     * @param {Function} handle The Event Callback Function.
     */
    static add(evtName, handle) { document.addEventListener(evtName, handle) }
    /**
     * Remove document event listener.
     * @param {String} evtName The Event Name.
     * @param {Function} handle The Event Callback Function.
     */
    static remove(evtName, handle) { document.removeEventListener(evtName, handle) }
}

//#endregion

//#region LocalStorage class

class LocalStorage {
    constructor() {
        this._name = ''
        this._data = null
        this._ttl = 0;
    };
    //-- public methods.
    checkExist() {
        if (!this.data) {
            this.data = this.getDefault();
            this.save();
        }
    };
    getDefault() { return {} };
    save() {
        if (!this._name) return; // no name specificed.
        let ttl = (this._ttl) ? this._ttl : 0;
        nlib.storage.set(this._name, this._data, { TTL: ttl }); // 1 days.
    };
    load() {
        if (!this._name) return; // no name specificed.
        let ttl = (this._ttl) ? this._ttl : 0;
        this._data = nlib.storage.get(this._name);
    };
    //-- public properties.
    get name() { return this._name; };
    set name(value) { this._name = value; };
    get data() { return this._data; };
    set data(value) { this._data = value; };
    get ttl() { return this._ttl; };
    set ttl(value) { this._ttl = value; };
};

//#endregion

//#region UserPerference class

class UserPerference extends LocalStorage {
    constructor() {
        super();
        this.name = 'uperf'
        this.ttl = 0;
        this._prefchanged = null;
        this.load();
        this.checkExist();
    };
    //-- public methods.
    getDefault() { return { langId: 'EN' } };
    load() { super.load(); };
    save() { super.save(); };
    //-- public properties.
    get langId() {
        if (!this.data) this.checkExist();
        return this.data.langId;
    };
    set langId(value) {
        if (!this.data) this.checkExist();
        this.data.langId = value;
    };
};

//#endregion

//#region DbApi class (required for call api)

class DbApi {
    static parse(r) {        
        let ret = { records: null, errors: null, out: null };
        if (r && r.result) {
            //console.log(r.result)
            ret.records = r.result.data;
            ret.out = r.result.out;
            ret.errors = r.result.errors;
        }
        return ret;
    }
}

const api = DbApi; // create shortcur variable.

//#endregion

//#region LanguageService class

/** app language changed. */
window.events.name.LanguageChanged = 'app:language:change';

class LanguageService {
    constructor() {
        this.pref = new UserPerference();
        this.pref.load(); // load once.
        this.languages = [];
        this.langId = LanguageService.defaultId;
        this.current = LanguageService.defaultLang;
        this.loaded = false;
    }
    getLanguages() {
        let self = this;
        let fn = (r) => {
            let data = api.parse(r);
            self.languages = (data && data.records) ? data.records : [];
            self.change(self.pref.langId, true); // set langId from preference.
            self.loaded = true;
        }
        XHR.get('/api/languages', { enable: true }, fn);
    }
    findLanguageIndex(langId) {
        let ids = this.languages.map(lang => lang.langId);
        return ids.indexOf(langId);
    }
    change(langId, forced) {
        let newId = LanguageService.checkId(langId)
        if (this.langId != newId || forced) {
            this.langId = newId;
            let idx = this.findLanguageIndex(newId);
            this.current = (idx === -1) ? LanguageService.defaultLang : this.languages[idx];
            // keep langid to storage.
            this.pref.langId = this.current.langId;
            this.pref.save();
            // Raise event.
            events.raise(events.name.LanguageChanged);
        }
    }
    static get defaultId() { return 'EN' }
    static get defaultLang() { 
        return {
            Description: "English",
            Enabled: true,
            SortOrder: 1,
            flagId: "US",
            langId: "EN"
        } 
    }
    static checkId(langId) { 
        return (langId) ? langId.toUpperCase() : LanguageService.defaultId
    }
}

; (function () {
    //console.log('Init language service...');
    window.lang = window.lang || new LanguageService();
    lang.getLanguages();
})();

//#endregion

//#region ScreenService class

/** app screen changed. */
window.events.name.ScreenChanged = 'app:screen:change';

class ScreenService {
    constructor() {
        this.current = {
            screenId: ''
        };
    }
    show(screenId) {
        if (this.current.screenId !== screenId) {
            // change screen id.
            this.current.screenId = screenId
            // Raise event.
            events.raise(events.name.ScreenChanged)
        }
    }
    is(screenId) { return this.current.screenId === screenId }
}
; (function () {
    //console.log('Init screen service...');
    window.screens = window.screens || new ScreenService();
})();

//#endregion

//#region SidebarService class

/** app sidebar changed. */
window.events.name.SidebarStateChanged = 'app:sidebar:statechange';

class SidebarService {
    constructor() {
        this.shown = false
    }
    show() {
        if (!this.shown) {
            this.shown = true
            // Raise event.
            events.raise(events.name.SidebarStateChanged)
        }
    }
    hide() {
        if (this.shown) {
            this.shown = false
            // Raise event.
            events.raise(events.name.SidebarStateChanged)
        }
    }
}

; (function () {
    //console.log('Init screen service...');
    window.sidebar = window.sidebar || new SidebarService();
})();

//#endregion