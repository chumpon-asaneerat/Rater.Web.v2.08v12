//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));

//#endregion

//#region exec/validate wrapper method

const exec = async (db, callback) => {
    let ret;
    let connected = await db.connect();
    if (connected) {
        ret = await callback();
        await db.disconnect();
    }
    else {
        ret = db.error(db.errorNumbers.CONNECT_ERROR, 'No database connection.');
    }
    return ret;
}
const validate = (db, data) => {
    let result = data;
    if (!result) {
        result = db.error(db.errorNumbers.NO_DATA_ERROR, 'No data returns');
    }
    else {
        result = checkForError(data);
    }
    return result;
}
const checkForError = (data) => {
    let result = data;
    if (result.out && result.out.errNum && result.out.errNum !== 0) {
        result.errors.hasError = true;
        result.errors.errNum = result.out.errNum;
        result.errors.errMsg = result.out.errMsg;
    }
    return result;
}

//#endregion

//#region Urls

const getFullUrl = (req) => {
    return req.protocol + '://' + req.get('hostname') + req.originalUrl;
}
const getRoutePath = (req) => {
    let url = getFullUrl(req);
    let rootUrl = req.protocol + '://' + req.get('hostname');
    let ret = url.replace(rootUrl, '');
    return ret;
}
const isStartsWith = (src, sPath) => {
    let lsrc = src.toLowerCase();
    if (lsrc.charAt(0) === '/') lsrc = lsrc.substring(1); // remove slash
    let lpath = sPath.toLowerCase();
    if (lpath.charAt(0) === '/') lpath = lpath.substring(1); // remove slash
    let ret = lsrc.startsWith(lpath);
    return ret;
}
const isHome = (url) => {
    let lsrc = url.toLowerCase();
    if (lsrc.charAt(0) === '/') lsrc = lsrc.substring(1); // remove slash
    let ret = (lsrc.length === 0);
    return ret;
}
const isEDL = (url) => { return isStartsWith(url, 'edl'); }
const isCustomer = (url) => { return isStartsWith(url, 'customer'); }
const isDevice = (url) => { return isStartsWith(url, 'rater'); }

//#endregion

//#region Cookies

const hasValue = (obj, name) => {
    let ret = false;
    ret = (obj && obj[name] !== undefined && obj[name] !== null);
    return ret;
}
const getValue = (obj, name) =>{
    let ret = '';
    ret = (hasValue(obj, name)) ? obj[name] : null;
    ret = (ret) ? ret : '';
    return ret;
}

const getRater = (req, res) => {
    return (res.locals.rater) ? res.locals.rater : null;
}
const getSecure = (req, res) => {
    let rater = getRater(req, res)
    return (rater) ? rater.secure : null;
}



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
const saveCookies = (req, res) => {
    // write secure object to cookie.
    let rater = res.locals.rater;
    if (!rater || !rater.mode) {
        initCookies(req, res)
    }
    WebServer.signedCookie.writeObject(req, res, rater, WebServer.expires.in(5).years);
    // write client access cookie.
    WebServer.cookie.writeObject(req, res, rater.secure, WebServer.expires.in(5).years);    
}
const loadCookies = (req, res) => {
    res.locals.rater = WebServer.signedCookie.readObject(req, res);
    let rater = res.locals.rater;
    if (!rater || !rater.mode) {
        initCookies(req, res)
    }
    return rater;
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

RaterSecure.EDL = class {
    //#region middleware methods

    static checkAccess(req, res, next) {
    }
    static checkUsers(req, res) {
        RaterSecure.checkUsers()
    }
    static signin(req, res) {
        RaterSecure.signin()
    }
    static signout(req, res) {
    }
    static changeCustomer(req, res) {
    }

    //#endregion
}

RaterSecure.Customer = class {
    //#region middleware methods

    static checkAccess(req, res, next) {
    }
    static checkUsers(req, res) {
        RaterSecure.checkUsers()
    }
    static signin(req, res) {
        RaterSecure.signin()
    }
    static signout(req, res) {
    }
    static changeCustomer(req, res) {
    }

    //#endregion
}

RaterSecure.Device = class {
    //#region middleware methods
    
    static checkAccess(req, res, next) {
    }
    static signin(req, res) {
        RaterSecure.signin()
    }
    static signout(req, res) {
    }
    static changeCustomer(req, res) {
    }

    //#endregion
}

//#endregion

module.exports.RaterSecure = exports.RaterSecure = RaterSecure;
