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

//#region RaterStorage

class RaterStorage {
    constructor(req, res) {
        this.req = req
        this.res = res
        if (!this.res.locals.rater) {
            // auto load if local var is null or undefined
            // this normally should execute on first middleware method
            // i.e. secure.checkAccess.
            this.load()
        }
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
    get account() {
        let ret = null;
        if (this.secure && this.secure.mode && this.secure.mode !== '') {
            let mode = this.secure.mode
            ret = this.secure[mode]
        }
        return ret;
    }
}

//#endregion

//#region Secure API classes.

class api {
    static hasMemberType(memberType) { return memberType !== undefined && memberType != null }
}
api.CheckAccess = class {
    static prepare(req, res) {
        //let params = WebServer.parseReq(req).data
        let storage = new RaterStorage(req, res)
        let params = {
            mode: '',
            accessId: ''
        }
        // default mode (customer)
        let mode = (storage.secure) ? storage.secure.mode : null
        if (mode) {
            params.mode = mode
            params.accessId = (storage.secure[mode]) ? storage.secure[mode].accessId : ''
        }        
        //console.log(params)
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
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.mode = 'device' // overide mode
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
        let ref = api.DeviceSignIn
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.DeviceSignIn
        ref.exec(req, res, (result) => {
            WebServer.sendJson(req, res, result)
        })
    }
}
api.DeviceSignOut = class {
    static prepare(req, res) {
        //let params = WebServer.parseReq(req).data
        let storage = new RaterStorage(req, res)
        let mode = 'device'
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
        let ref = api.DeviceSignOut
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.DeviceSignOut
        ref.exec(req, res, (result) => {
            WebServer.sendJson(req, res, result)
        })
    }
}

//#endregion

//#region RaterSecure class

class RaterSecure {
    //#region middleware methods

    static checkAccess(req, res, next) {
        api.CheckAccess.exec(req, res, (result) => {
            if (dbutils.hasData(result)) {
                let storage = new RaterStorage(req, res)
                let row = result.data[0];
                //console.log(row)
                let mode = storage.secure.mode
                // for secure
                storage.secure[mode].customerId = row.CustomerId
                storage.secure[mode].memberId = row.MemberId
                storage.secure[mode].memberType = row.MemberType
                // for client
                storage.client.keys.user = {
                    memberId: row.MemberId,
                    memberType: row.MemberType,
                }
                storage.commit()
            }
            if (next) next();
        })
    }
    static checkRedirect(req, res, next) {
        let storage = new RaterStorage(req, res)
        let url = urls.getRoutePath(req)
        let accessObj = storage.account
        let mtype = 0
        let fn;
        if (accessObj) {
            if (api.hasMemberType(accessObj.memberType)) {
                mtype = accessObj.memberType
            }
            // get routes for specificed member type
            fn = urls.goHome(mtype)
        }
        if (fn) {
            fn(req, res, next, url)
        }
        else {
            // Redirect to root url.
            RaterSecure.redirectToHome(req, res, next)
        }
    }
    static checkDevice(req, res, next) {
        let storage = new RaterStorage(req, res)
        storage.secure.mode = 'device'
        storage.commit()
        if (next) next()
    }
    static redirectToHome(req, res, next) {
        let url = urls.getRoutePath(req)
        if (url === '/' && next) {
            // if current url is root (home) so allow to process next chain method
            next()
        }
    }
    static deviceRedirect(req, res, next) {
        let url = urls.getRoutePath(req)
        if (urls.isDeviceRoute(url) && next) {
            // valid device route so allow to process next chain method
            next()
        }
        else {
            // invalid route so redirect to device home.
            res.redirect('/rater')
        }
    }

    //#endregion

    //#region api routes methods

    static clientSignIn(req, res) {
        api.ClientSignIn.exec(req, res, (result) => {
            if (dbutils.hasData(result)) {
                let storage = new RaterStorage(req, res)
                let params = WebServer.parseReq(req).data
                let mode = (params.IsEDLUser) ? 'edl' : 'customer'
                storage.secure.mode = mode
                storage.secure[mode].accessId = result.out.accessId
                // set client side id.
                storage.client.keys.id1 = result.out.accessId
                storage.commit();
            }
            WebServer.sendJson(req, res, result);
        })
    }
    static clientSignOut(req, res) { 
        api.ClientSignOut.exec(req, res, (data) => {
            let storage = new RaterStorage(req, res)
            storage.reset();
            // clear client side id.
            storage.client.keys.id1 = ''
            storage.client.keys.user = {}
            storage.commit();
            WebServer.sendJson(req, res, data);
        })
    }
    static deviceSignIn(req, res) { 
        api.ClientSignIn.exec(req, res, (result) => {
            let storage = new RaterStorage(req, res)
            if (dbutils.hasData(result)) {
                let mode = 'device'
                storage.secure.mode = mode
                storage.secure[mode].accessId = result.out.accessId
                // set client side id.
                storage.client.keys.id2 = result.out.accessId
                storage.commit();
            }
            WebServer.sendJson(req, res, result);
        })
    }
    static deviceSignOut(req, res) { 
        api.DeviceSignOut.exec(req, res, (data) => {
            let storage = new RaterStorage(req, res)
            // clear client side id.
            storage.client.keys.id2 = ''
            storage.client.keys.user = {}
            storage.reset();
            storage.commit();
            WebServer.sendJson(req, res, data);
        })
    }
    
    //#endregion
}

//#endregion

module.exports.RaterSecure = exports.RaterSecure = RaterSecure;
module.exports.RaterStorage = exports.RaterStorage = RaterStorage;
