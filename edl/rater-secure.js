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

//#region API classes.

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
        let ref = api.SignIn
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.SignIn
        ref.exec(req, res, (result) => {
            WebServer.sendJson(req, res, result)
        })
    }
}
api.ClientSignOut = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.userId = null
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
        let ref = api.SignOut
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, callback)
        })
    }
    static route(req, res, next) {
        let ref = api.SignOut
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

//#region Cookies


const createSecureCookie = () => {
    let obj = {
        mode: 'customer',
        edl: {
            accessId: 'ACC001',
            memberId: 'M0001',
            memberType: 0,
            customerId: 'EDL-2020030001'
        },
        customer: {
            accessId: 'ACC001',
            memberId: 'M0001',
            memberType: 0,
            customerId: 'EDL-2020030001'
        },
        device: {
            accessId: 'ACC001',
            memberId: 'M0001',
            memberType: 0,
            customerId: 'EDL-2020030001',
            deviceId: 'D0001'
        }
    }
    return obj;
}
const createClientCookie = () => {
    let obj = {
        screenId: 'sample',
        selection: {
            'customerId': 'EDL-2020030001',
            'memberId': 'M0001',
        }
    }
    return obj;
}

const checkLocalVar = (req, res) => {
    // Every time request occur the res.locals.rater should be null
    // So we need to get exists cookie to re-assigned value into
    // local variable res.locals.rater on each time.
    res.locals.rater = {
        secure: cookies.loadSignedCookies(req, res, 'secure'),
        client: cookies.loadCookies(req, res, 'client')
    }
    // Check Secure Cookie
    if (!res.locals.rater.secure) {
        //console.log('No secure cookie.')
        let secure = createSecureCookie()
        cookies.saveSignedCookies(req, res, 'secure', secure)
        // set to local variable
        res.locals.rater.secure = secure
    }

    // Check Client Cookie
    if (!res.locals.rater.client) {
        //console.log('No client cookie.')
        let client = createClientCookie()
        cookies.saveCookies(req, res, 'client', client)
        // set to local variable
        res.locals.rater.client = client
    }

    //console.log('secure:', res.locals.rater.secure)
    //console.log('client:', res.locals.rater.client)
}

/*
const updateSecureObjs = [
    { 
        mode:'edl', 
        update: (secureObj, updateObj) => {
            secureObj.edl.accessId = updateObj.AccessId
            secureObj.edl.customerId = updateObj.CustomerId
            secureObj.edl.memberId = updateObj.MemberId
            secureObj.edl.memberType = updateObj.MemberType
        } 
    },
    { 
        mode:'customer', 
        update: (secureObj, updateObj) => {
            secureObj.customer.accessId = updateObj.AccessId
            secureObj.customer.customerId = updateObj.CustomerId
            secureObj.customer.memberId = updateObj.MemberId
            secureObj.customer.memberType = updateObj.MemberType
        } 
    },
    { 
        mode:'device', 
        update: (secureObj, updateObj) => {
            secureObj.device.accessId = updateObj.AccessId
            secureObj.device.customerId = updateObj.CustomerId
            secureObj.device.memberId = updateObj.MemberId
            secureObj.device.memberType = updateObj.MemberType
            secureObj.device.deviceId = updateObj.DeviceId
        } 
    }
]

const updateSecureObjMaps = updateSecureObjs.map(obj => obj.mode )

const updateSecureObj = (req, res, obj) => {
    if (!res.locals.rater) {
        // setup value for access in all routes.
        initCookies(req, res);
    }
    let rater = res.locals.rater;
    if (obj) {        
        let idx = updateSecureObjMaps.indexOf(obj.mode)
        let fn = (idx !== -1 ) ? updateSecureObjs[idx] : null
        if (fn) {
            fn.update(rater.secure, obj)
            // write secure object to cookie.
            saveCookies(req, res);
        }
        // test write secure object to cookie.
        //saveCookies(req, res);
    }
}
*/

//#endregion

class RaterStorage {
    constructor(req, res) {
        this.req = req
        this.res = res
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
    get secure() {
        if (!this.res.locals.rater.secure) this.res.locals.rater.secure = { mode: '' }
        if (!this.res.locals.rater.secure.edl) this.res.locals.rater.secure.edl = { }
        if (!this.res.locals.rater.secure.customer) this.res.locals.rater.secure.customer = { }
        if (!this.res.locals.rater.secure.device) this.res.locals.rater.secure.device = { }

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

    static checkAccess(req, res, next) {
        // 1. Check current secure object
        //    1.1. no secure object goto step 2.
        //    1.2. secure object exists check database.
        //    1.2.1. if match accessid and mode redirect to proper url.
        //    1.2.2. if accessid not found goto step 2.
        // 2. forward to next middleware route.

        //checkLocalVar(req, res)
        let storage = new RaterStorage(req, res);
        storage.load();
        storage.secure.mode = 'edl'
        storage.secure.edl.accessId = 'XYZ123'
        storage.client.keys.id1 = 'K01'
        storage.commit();

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
        api.SignIn.exec(req, res, (data) => {
            WebServer.sendJson(req, res, data);
        })
    }
    static clientSignOut(req, res) { 
    }
    static deviceSignIn(req, res) { 
    }
    static deviceSignOut(req, res) { 
    }

    //#endregion
}

//#endregion

module.exports.RaterSecure = exports.RaterSecure = RaterSecure;
module.exports.RaterStorage = exports.RaterStorage = RaterStorage;
