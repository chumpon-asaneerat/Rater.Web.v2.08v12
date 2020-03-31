const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const Cryptr = require('cryptr');
const cryptr = new Cryptr('YOUR_KEY@123');

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
    static saveSignedCookies = (req, res, key, obj) => {
        // write secure object to cookie.
        let data = {}
        data[key] = cryptr.encrypt(JSON.stringify(obj))
        WebServer.signedCookie.writeObject(req, res, data, WebServer.expires.in(5).years);
    }
    static loadSignedCookies = (req, res, key) => {
        // read secure cookie to object.
        let data = WebServer.signedCookie.readObject(req, res);
        let obj = JSON.parse(cryptr.decrypt(data[key]))
        return obj;
    }
    static saveCookies = (req, res, key, obj) => {
        // write object to cookie (client accessible).
        // Note: the httpOnly flag need to set to false to allow access via 
        // client side javascript.
        let data = {}
        data[key] = JSON.stringify(obj)
        WebServer.cookie.writeObject(req, res, data, WebServer.expires.in(5).years, false);
    }
    static loadCookies = (req, res, key) => {
        // read cookie to object (client accessible).
        let data = WebServer.cookie.readObject(req, res);
        let obj = JSON.parse(data[key])
        return obj;
    }
}

module.exports.CookieUtils = exports.CookieUtils = CookieUtils;
