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
const updateSecureObj = (req, res, obj) => {
    if (!res.locals.rater) {
        // setup value for access in all routes.        
        res.locals.rater = {
            secure : {
                accessId: '',
                /*
                deviceId: '',
                customerId: '',
                memberId: '',
                memberType: 0,
                IsEdlUser: false,
                EDLCustomerId: null
                */
            }
        }
    }
    let rater = res.locals.rater;
    if (obj) {
        rater.secure.accessId = obj.AccessId;
        /*
        rater.secure.deviceId = obj.DeviceId; // this value exist only on device screen.
        rater.secure.customerId = obj.CustomerId;
        rater.secure.memberId = obj.MemberId;
        rater.secure.memberType = obj.MemberType;
        rater.secure.IsEdlUser = obj.IsEDLUser,
        rater.secure.EDLCustomerId = obj.EDLCustomerId
        */
    }
}

//#endregion

//#region RaterSecure class

class RaterSecure {
    //#region middleware methods

    static signin(req, res) {        
    }

    //#endregion
}

RaterSecure.EDL = class {
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

RaterSecure.Customer = class {
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