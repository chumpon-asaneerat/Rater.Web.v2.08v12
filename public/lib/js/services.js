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


//#region OSD

//#region avaliable events name for OSD Service

/** Show OSD. */
window.events.name.ShowOsd = 'app:osd:show';
/** Update OSD. */
window.events.name.UpdateOsd = 'app:osd:update';
/** Hide OSD. */
window.events.name.HideOsd = 'app:osd:hide';

//#endregion

//#region OSDService class

class OSDService {
    constructor() {
        this.handle = null;
        this.shown = false;
        this.lastUpdate = new Date();
        /** timeout in millisecond. */
        this.timeout = 5000;
    }
    get elapse() { return new Date() - this.lastUpdate; }
    show() {
        let self = this;        
        if (!this.shown) {
            this.lastUpdate = new Date();
            this.shown = true;
            // raise message
            events.raise(events.name.ShowOsd);
            this.handle = setInterval(() => {
                if (self.elapse > self.timeout) self.hide()
            }, 100);
        }
        // not show so show osd
        events.raise(events.name.ShowOsd)
    }
    info(message) {
        this.lastUpdate = new Date();
        if (!this.shown) this.show();
        // raise message
        events.raise(events.name.UpdateOsd, { msg: message, type: 'info' })
    }
    warn(message) {
        this.lastUpdate = new Date();
        if (!this.shown) this.show();
        // raise message
        events.raise(events.name.UpdateOsd, { msg: message, type: 'warn' })
    }
    err(message) {
        this.lastUpdate = new Date();
        if (!this.shown) this.show();
        // raise message
        events.raise(events.name.UpdateOsd, { msg: message, type: 'error' })
    }
    hide() {
        if (this.shown) {
            //console.log('OSD hide.')
            clearInterval(this.handle);
        }
        this.lastUpdate = new Date();
        this.handle = null;
        this.shown = false;
        // raise message
        events.raise(events.name.HideOsd)
    }
}

; (function () {
    window.osd = window.osd || new OSDService()
})()

//#endregion

//#endregion

//#region Language

//#region avaliable events name for Language Service

/** app language changed. */
window.events.name.LanguageChanged = 'app:language:change';

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

//#region LanguageService class

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
    change(langId, forced) {
        let newId = (langId) ? langId.toUpperCase() : LanguageService.defaultId;
        if (this.langId != newId || forced) {
            this.langId = newId;
            let ids = this.languages.map(lang => lang.langId);
            let idx = ids.indexOf(newId);
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
}

; (function () {
    //console.log('Init language service...');
    window.lang = window.lang || new LanguageService();
    lang.getLanguages();
})();

//#endregion

//#endregion

//#region Screen

//#region avaliable events name for Screen Service

/** app screen changed. */
window.events.name.ScreenChanged = 'app:screen:change';

//#endregion

//#region ScreenService class

class ScreenService {
    constructor() {
        this.current = {
            screenId: ''
        };
    }
    show(screenId) {
        if (this.current.screenId !== screenId) {
            // change screen id.
            this.current.screenId = screenId;
            // Raise event.
            events.raise(events.name.ScreenChanged);
        }
    }
}
; (function () {
    //console.log('Init screen service...');
    window.screens = window.screens || new ScreenService();
})();

//#endregion

//#endregion

//#region Content

//#region avaliable events name for Content Service

/** app contents changed. */
window.events.name.ContentChanged = 'app:contents:changed';

//#endregion

//#region ContentService class

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

//#endregion

//#region Master Data Loader

//#region avaliable events name for Master Data Loaders

/** Master: Member Type List Changed. */
window.events.name.MemberTypeListChanged = 'app:master:membertype:list:changed';
/** Master: Device Type List Changed. */
window.events.name.DeviceTypeListChanged = 'app:master:devicetype:list:changed';
/** Master: Period Unit List Changed. */
window.events.name.PeriodUnitListChanged = 'app:master:periodunit:list:changed';
/** Master: Limit Unit List Changed. */
window.events.name.LimitUnitListChanged = 'app:master:limitunit:list:changed';
/** Master: License Type List Changed. */
window.events.name.LicenseTypeListChanged = 'app:master:licensetype:list:changed';
/** Master: License Feature List Changed. */
window.events.name.LicenseFeatureListChanged = 'app:master:licensefeature:list:changed';

//#endregion

//#region Master Data Loaders and Service classes

class MemberTypesLoader {
    constructor() {
        this.content = null;
        this.current = null;
        let self = this;
        let contentChanged = (e) => {
            self.updateCurrent();
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load() {
        let self = this;
        let url = '/api/membertypes';
        let paramObj = {};
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            self.updateCurrent();
        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {        
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        //console.log('Current:', ret);
        return ret;
    }
    updateCurrent() {
        this.current = this.getCurrent();
        // raise event
        events.raise(events.name.MemberTypeListChanged)
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}

class PeriodUnitsLoader {
    constructor() {
        this.content = null;
        this.current = null
        let self = this;
        let contentChanged = (e) => {
            self.updateCurrent();
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load() {
        let self = this;
        let url = '/api/periodunits';
        let paramObj = {};
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            self.updateCurrent();
        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        //console.log('Current:', ret);
        return ret;
    }
    updateCurrent() {
        this.current = this.getCurrent();
        // raise event
        events.raise(events.name.PeriodUnitListChanged)
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}

class LimitUnitsLoader {
    constructor() {
        this.content = null;
        this.current = null;
        let self = this;
        let contentChanged = (e) => {
            self.updateCurrent();
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load() {
        let self = this;
        let url = '/api/limitunits';
        let paramObj = {};
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            self.updateCurrent();
        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        //console.log('Current:', ret);
        return ret;
    }
    updateCurrent() {
        this.current = this.getCurrent();
        // raise event
        events.raise(events.name.LimitUnitListChanged)
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}

class DeviceTypesLoader {
    constructor() {
        this.content = null;
        this.current = null;
        let self = this;
        let contentChanged = (e) => {
            self.updateCurrent();
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load() {
        let self = this;
        let url = '/api/devicetypes';
        let paramObj = {};
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            self.updateCurrent();
        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        return ret;
    }
    updateCurrent() {
        this.current = this.getCurrent();
        // raise event
        events.raise(events.name.DeviceTypeListChanged)
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}

class LicenseTypesLoader {
    constructor() {
        this.content = null;
        this.current = null;
        let self = this;
        let contentChanged = (e) => {
            self.updateCurrent();
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load() {
        let self = this;
        let url = '/api/licensetypes';
        let paramObj = {};
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            self.updateCurrent();
        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        //console.log('Current:', ret);
        return ret;
    }
    updateCurrent() {
        this.current = this.getCurrent();
        // raise event
        events.raise(events.name.LicenseFeatureListChanged)
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}

class LicenseFeaturesLoader {
    constructor() {
        this.content = null;
        this.current = null;
        let self = this;
        let contentChanged = (e) => {
            self.updateCurrent();
        }
        document.addEventListener(events.name.LanguageChanged, contentChanged)
    }
    load() {
        let self = this;
        let url = '/api/licensefeatures';
        let paramObj = {};
        let fn = (r) => {
            let data = api.parse(r);
            self.content = data.records;
            self.updateCurrent();
        }
        XHR.get(url, paramObj, fn);
    }
    getCurrent() {
        let match = this.content && this.content[this.langId];
        let ret = (match) ? this.content[this.langId] : (this.content) ? this.content['EN'] : null;
        //console.log('Current:', ret);
        return ret;
    }
    updateCurrent() {
        this.current = this.getCurrent();
        // raise event
        events.raise(events.name.LicenseFeatureListChanged)
    }
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}
class MasterService {
    constructor() {
        this.membertypes = new MemberTypesLoader();
        this.periodunits = new PeriodUnitsLoader();
        this.limitunits = new LimitUnitsLoader();
        this.devicetypes = new DeviceTypesLoader();
        this.licesetypes = new LicenseTypesLoader();
        this.licensefeatures = new LicenseFeaturesLoader();
    }
    /*
    load() {
        this.membertypes.load()
        this.periodunits.load()
        this.limitunits.load()
        this.devicetypes.load()
        this.licesetypes.load()
        this.licensefeatures.load()
    }
    */
    get langId() { 
        return (lang.current) ? lang.current.langId : 'EN';
    }
}

;(function () {
    //console.log('Init content service...');
    window.master = window.master || new MasterService();
    //master.load();
})();

//#endregion

//#endregion

//#region Secure

//#region avaliable events name for 

/** Secure: Client User SignIn User List Changed. */
window.events.name.UserListChanged = 'app:secure:user:list:changed';
/** Secure: Client User SignIn Failed. */
window.events.name.UserSignInFailed = 'app:secure:user:signin:failed';

//#endregion

//#region SecureService class

class SecureService {
    constructor() {
        this.content = null;
        this.account = { username: '', password: ''}
    }
    reset() {
        this.content = null;
        this.account = { username: '', password: ''}
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
        console.log('Sign In:', paramObj);
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
    nav(url) {
        nlib.nav.gotoUrl(url);
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

//#endregion

class SecureService2
{
    signin(customerId) {
        // may need to changed api route.
        let url = '/api/signin'
        let paramObj = {
            customerId: customerId,
            userName: this.account.username,
            passWord: this.account.password,
            IsEDLUser: this.account.IsEDLUser
        }
        console.log('Sign In:', paramObj);
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
    nav(url) {
        nlib.nav.gotoUrl(url);
    }
}

window.secure2 = window.secure2 || new SecureService2();
