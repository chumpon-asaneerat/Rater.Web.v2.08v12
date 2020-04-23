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

//#region ContentService class

/** app contents changed. */
window.events.name.ContentChanged = 'app:contents:changed';

class ContentService {
    constructor() {
        this.content = null;
        this.current = null;
        let self = this;
        let contentChanged = (e) => {
            self.current = self.getCurrent();
            // Raise event.
            events.raise(events.name.ContentChanged);
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load(url, paramObj) {
        let self = this;
        let fn = (r) => {
            let data = api.parse(r);
            //console.log(data.records)
            self.content = data.records;
            self.current = self.getCurrent();
            // Raise event.
            events.raise(events.name.ContentChanged);

        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        //console.log('Current:', ret);
        return ret;
    }
    getScreenContent() {
        let curr = this.getCurrent()
        let scrId = screens.current.screenId
        let ret = (curr && curr.screens) ? curr.screens[scrId] : null
        return ret
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}
; (function () {
    //console.log('Init content service...');
    window.contents = window.contents || new ContentService();
    let href = window.location.href;
    if (href.endsWith('#')) href = window.location.href.replace('#', '');
    if (!href.endsWith('/')) href = href + '/';
    let url = href.replace('#', '') + 'contents';
    contents.load(url); // load contents.
})();

//#endregion

//#region SecureService class

/** Secure: Client User SignIn User List Changed. */
window.events.name.UserListChanged = 'app:secure:user:list:changed';
/** Secure: Client User SignIn Failed. */
window.events.name.UserSignInFailed = 'app:secure:user:signin:failed';

class SecureService {
    constructor() {
        this.content = null;
        this.account = { username: '', password: '', IsEDLUser: false }
    }
    reset() {
        this.content = null;
        this.account = { username: '', password: '', IsEDLUser: false }
    }
    verifyUsers(username, pwd) {
        let url = '/api/validate-accounts'
        this.account = { username: username, password: pwd}

        let self = this;
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            // Raise event.
            events.raise(events.name.UserListChanged);
        }
        XHR.postJson(url, this.account, fn);
    }
    signin(customerId) {
        // may need to changed api route.
        let url = '/api/signin'
        let paramObj = {
            customerId: customerId,
            userName: this.account.username,
            passWord: this.account.password,
            IsEDLUser: this.account.IsEDLUser
        }
        //console.log('Sign In:', paramObj);
        let fn = (r) => {
            let data = api.parse(r);
            let err = data.errors;
            if (err && err.hasError) {
                // Raise event.
                events.raise(events.name.UserSignInFailed, { error: err });
            }
            else {
                //console.log('Sign In Success.');
                nlib.nav.gotoUrl('/', true);
            }            
        }
        XHR.postJson(url, paramObj, fn);
    }
    signout() {
        // may need to changed api route.
        let url = '/api/signout'
        let fn = (r) => {
            //console.log(r);
            //console.log('sign out detected.');
            nlib.nav.gotoUrl('/', true);
        }
        XHR.postJson(url, this.account, fn);
    }
    changeCustomer(customerId) {
        // may need to changed api route.
        let url = '/api/change-customer'
        let paramObj = {
            customerId: customerId
        }
        //console.log('Sign In:', paramObj);
        let fn = (r) => {
            let data = api.parse(r);
            let err = data.errors;
            if (err && err.hasError) {
                // change customer failed.
                //console.log('Change customer failed:', err)
            }
            else {
                //console.log('Change customer Success.');
                nlib.nav.gotoUrl('/', true);
            }            
        }
        XHR.postJson(url, paramObj, fn);
    }
    get users() {
        let ret = []
        if (this.content) {
            let usrs = (this.content[lang.langId]) ? this.content[lang.langId] : (this.content['EN']) ? this.content['EN'] : [];
            ret = usrs;
        }
        return ret;
    }
}

window.secure = window.secure || new SecureService();

//#endregion