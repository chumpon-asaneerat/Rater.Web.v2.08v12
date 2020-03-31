const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));

class CookieUtils {
    static hasValue(obj, name) {
        let ret = false;
        ret = (obj && obj[name] !== undefined && obj[name] !== null);
        return ret;
    }
    static getValue(obj, name) {
        let ret = '';
        ret = (hasValue(obj, name)) ? obj[name] : null;
        ret = (ret) ? ret : '';
        return ret;
    }
    static saveSignedCookies = (req, res, obj) => {
        // write secure object to cookie.
        WebServer.signedCookie.writeObject(req, res, obj, WebServer.expires.in(5).years);
    }
    static loadSignedCookies = (req, res) => {
        // read secure cookie to object.
        let obj = WebServer.signedCookie.readObject(req, res);
        return obj;
    }
    static saveCookies = (req, res, obj) => {
        // write object to cookie (client accessible).
        // Note: the httpOnly flag need to set to false to allow access via 
        // client side javascript.
        WebServer.cookie.writeObject(req, res, obj, WebServer.expires.in(5).years, false);
    }
    static loadCookies = (req, res) => {
        // read cookie to object (client accessible).
        let obj = WebServer.cookie.readObject(req, res);
        return obj;
    }
}

module.exports.CookieUtils = exports.CookieUtils = CookieUtils;
