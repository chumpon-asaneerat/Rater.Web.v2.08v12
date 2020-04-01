//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));

const dbutils = require('./utils/db-utils').DbUtils;
const cookies = require('./utils/cookie-utils').CookieUtils;
const urls = require('./utils/url-utils').UrlUtils;

//#endregion

//#region Secure API classes.

class api {}
api.CheckAccess = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.accessId = null
        params.mode = null
        return params
     }
    static async call(db, params) {
        return await db.CheckAccess(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        callback(result)
    }
    static exec(req, res, callback) {
        let ref = api.CheckAccess
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.CheckAccess
        ref.exec(req, res, (result) => {
            WebServer.sendJson(req, res, result)
        })
    }
}
api.ClientSignIn = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.mode = (params.IsEDLUser) ? 'edl' : 'customer'
        return params
     }
    static async call(db, params) {
        return await db.SignIn(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        callback(result)
    }
    static exec(req, res, callback) {
        let ref = api.ClientSignIn
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.ClientSignIn
        ref.exec(req, res, (result) => {
            WebServer.sendJson(req, res, result)
        })
    }
}
api.ClientSignOut = class {
    static prepare(req, res) {
        //let params = WebServer.parseReq(req).data
        let storage = new RaterStorage(req, res)
        let mode = storage.secure.mode
        let params = {
            accessId: storage.secure[mode].accessId,
            mode: mode
        }
        return params
     }
    static async call(db, params) {
        return await db.SignOut(params)
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data)
        callback(result)
    }
    static exec(req, res, callback) {
        let ref = api.ClientSignOut
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.ClientSignOut
        ref.exec(req, res, (result) => {
            WebServer.sendJson(req, res, result)
        })
    }
}
api.DeviceSignIn = class {
}

api.DeviceSignOut = class {
}

//#endregion

class RaterStorage {
    constructor(req, res) {
        this.req = req
        this.res = res
        this.load()
    }
    load() {
        if (this.req && this.res) {
            this.res.locals.rater = {
                secure: cookies.loadSignedCookies(this.req, this.res, 'secure'),
                client: cookies.loadCookies(this.req, this.res, 'client')
            }
        }
    }
    commit() {
        if (this.req && this.res) {
            cookies.saveSignedCookies(this.req, this.res, 'secure', this.secure)
            cookies.saveCookies(this.req, this.res, 'client', this.client)
        }
    }
    get rater() { return this.res.locals.rater; }
    reset() {
        if (this.secure && this.secure.mode && this.secure.mode !== '') {
            let mode = this.secure.mode
            // reset accessId in exist mode.
            this.res.locals.rater.secure[mode].accessId = ''
            this.res.locals.rater.secure[mode].memberId = ''
            this.res.locals.rater.secure[mode].memberType = 0
            // reset mode.
            this.secure.mode = '';
        }
    }
    get secure() {
        if (!this.res.locals.rater.secure) this.res.locals.rater.secure = { mode: '' }
        if (!this.res.locals.rater.secure.edl) this.res.locals.rater.secure.edl = {}
        if (!this.res.locals.rater.secure.customer) this.res.locals.rater.secure.customer = {}
        if (!this.res.locals.rater.secure.device) this.res.locals.rater.secure.device = {}

        return this.res.locals.rater.secure;
    }
    set secure(value) {
        this.res.locals.rater.secure = value;
    }
    get client() {
        if (!this.res.locals.rater.client) this.res.locals.rater.client = {}
        if (!this.res.locals.rater.client.keys) this.res.locals.rater.client.keys = {}
        if (!this.res.locals.rater.client.selection) this.res.locals.rater.client.selection = {}

        return this.res.locals.rater.client;
    }
    set client(value) {
        this.res.locals.rater.client = value;
    }
}

// Key notes:
// 1. res.locals var is used for pass data between middleware function.
// 2. Cookies object store/retrive can do via methods.
//    - WebServer.signedCookie.writeObject(req, res, obj, WebServer.expires.in(5).years)
//    - WebServer.cookie.writeObject(req, res, obj, WebServer.expires.in(5).years)
//    - WebServer.signedCookie.readObject(req, res)
//    - WebServer.cookie.readObject(req, res)


//#region RaterSecure class

class RaterSecure {
    //#region middleware methods

    static verifyStorage(req, res, next) {
        // 1. Check current secure object
        //    1.1. no secure object goto step 2.
        //    1.2. secure object exists check database.
        //    1.2.1. if match accessid and mode redirect to proper url.
        //    1.2.2. if accessid not found goto step 2.
        // 2. forward to next middleware route.
        
        let storage = new RaterStorage(req, res);
        console.log('secure:', storage.secure)
        console.log('client:', storage.client)

        if (next) next();

        //#region comment out
        /*
        // check access object is exists in signed cookie.
        let obj = loadCookies(req, res);
        if (!obj || !obj.mode) {
            // if cookie not exists create new one.
            updateSecureObj(req, res, obj)
        }
        let secure = getSecure(req, res);

        let db = new sqldb();
        let params = { 
            accessId: '',
            mode: secure.mode
        };

        if (secure.mode === 'edl') {
            params.accessId = secure.edl.accessId
        }
        else if (secure.mode === 'customer') {
            params.accessId = secure.customer.accessId
        }
        else {
        }
        let fn = async () => {
            return db.CheckAccess(params);
        }
        exec(db, fn).then(result => {
            if (!result.errors.hasError && result.data && result.data.length > 0) {
                let row = result.data[0];
                updateSecureObj(req, res, row);
            }
            if (next) next();
        });
        */
       //#endregion
    }

    //#endregion

    //#region api routes methods

    static clientSignIn(req, res) {
        api.ClientSignIn.exec(req, res, (data) => {
            if (data && !data.errors.hasError) {
                let storage = new RaterStorage(req, res)
                let params = WebServer.parseReq(req).data
                let mode = (params.IsEDLUser) ? 'edl' : 'customer'
                storage.secure.mode = mode
                storage.secure[mode].accessId = data.out.accessId
                // set client side id.
                storage.client.keys.id1 = data.out.accessId
                storage.commit();
            }
            WebServer.sendJson(req, res, data);
        })
    }
    static clientSignOut(req, res) { 
        api.ClientSignOut.exec(req, res, (data) => {
            let storage = new RaterStorage(req, res)
            // clear client side id.
            storage.client.keys.id1 = ''
            storage.reset();
            storage.commit();
            WebServer.sendJson(req, res, data);
        })
    }
    static deviceSignIn(req, res) { 
    }
    static deviceSignOut(req, res) { 
    }
    // From secure route.
    /*
    static signin(req, res) {
        let db = new sqldb();
        let params = WebServer.parseReq(req).data;
        let fn = async () => {
            return db.SignIn(params);
        }
        exec(db, fn).then(data => {
            let result = validate(db, data);
            if (result && !result.errors.hasError && result.out.errNum === 0) {
                let obj = {
                    accessId: result.out.accessId
                }
                WebServer.signedCookie.writeObject(req, res, obj, WebServer.expires.in(5).years);
            }
            WebServer.sendJson(req, res, result);
        })
    }
    */
    
    //#endregion
}

//#endregion

module.exports.RaterSecure = exports.RaterSecure = RaterSecure;
module.exports.RaterStorage = exports.RaterStorage = RaterStorage;
