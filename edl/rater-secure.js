//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));

const dbutils = require('./db-utils').DbUtils;
const urls = require('./url-utils').UrlUtils;
const cookies = require('./cookie-utils').CookieUtils;

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
api.SignIn = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.userId = null
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

//#endregion

//#region Cookies

/*
const initCookies = (req, res) => {
    // setup value for access in all routes.        
    res.locals.rater = {
        secure : {
            mode: "",
            edl : {
                accessId: '',
                memberId: '',
                memberType: 0,
                customerId: ''
            },
            customer: {
                accessId: '',
                memberId: '',
                memberType: 0,
                customerId: ''
            },
            device: {
                accessId: '',
                memberId: '',
                memberType: 0,
                customerId: '',
                deviceId: ''
            }
        }
    }
}
*/


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

    //#region routes methods

    static checkUsers(req, res) {
    }
    static signin(req, res) {
        let db = new sqldb();
        let params = WebServer.parseReq(req).data;

        let result = { text: 'signin', params: params }
        WebServer.sendJson(req, res, result);
        /*
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
        */
    }

    //#endregion
}

//#endregion

module.exports.RaterSecure = exports.RaterSecure = RaterSecure;
