//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));

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
    let rater = res.locals.rater;
    if (obj) {        
        let idx = updateSecureObjMaps.indexOf(obj.mode)
        let fn = (idx !== -1 ) ? updateSecureObjs[idx] : null
        if (fn) fn.update(rater.secure, obj)
    }
}

//#endregion

//#region RaterSecure class

class RaterSecure {
    //#region middleware methods

    static checkAccess(req, res, next) {
        // check access object is exists in signed cookie.
        let obj = WebServer.signedCookie.readObject(req, res);
        // if cookie not exists create new one.

        // original code.
        /*
        let db = new sqldb();
        let params = { 
            accessId: obj.accessId
        };
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

        // so after this step cookie should exists then process next step
        //if (next) next(req, res, next)
        if (next) next()
    }

    //#endregion

    //#region routes methods

    static checkUsers(req, res) {
    }
    static signin(req, res) {
        /*
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