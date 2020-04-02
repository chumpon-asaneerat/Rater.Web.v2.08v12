const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));

/*
const homeurls = [
    { code:   0, redirect: gotoHome },
    { code: 200, redirect: gotoAdmin },
    { code: 210, redirect: gotoExcuisive },
    { code: 280, redirect: gotoStaff },
    //{ code: 290, redirect: gotoDevice }, // not implements.
    { code: 100, redirect: gotoEDLAdmin },
    { code: 110, redirect: gotoEDLSupervisor },
    { code: 180, redirect: gotoEDLStaff },
    //{ code: 900, redirect: gotoEDLCustomer } // temporary comment out
]

const goHome = (memberType) => {
    let map = homeurls.map(urlObj => urlObj.code )
    let idx = map.indexOf(memberType)
    let ret = homeurls[0].redirect // default to root page.
    if (idx !== -1) {
        ret = homeurls[idx].redirect
    }
    return ret
}
*/

class UrlUtils {
    static getFullUrl(req) {
        return req.protocol + '://' + req.get('hostname') + req.originalUrl;
    }
    static getRoutePath(req) {
        let url = UrlUtils.getFullUrl(req);
        let rootUrl = req.protocol + '://' + req.get('hostname');
        let ret = url.replace(rootUrl, '');
        return ret;
    }
    static isStartsWith(src, sPath) {
        let lsrc = src.toLowerCase();
        if (lsrc.charAt(0) === '/') lsrc = lsrc.substring(1); // remove slash
        let lpath = sPath.toLowerCase();
        if (lpath.charAt(0) === '/') lpath = lpath.substring(1); // remove slash
        let ret = lsrc.startsWith(lpath);
        return ret;
    }
    static isHome(url) {
        let lsrc = url.toLowerCase();
        if (lsrc.charAt(0) === '/') lsrc = lsrc.substring(1); // remove slash
        let ret = (lsrc.length === 0);
        return ret;
    }
    //static isEDL(url) { return UrlUtils.isStartsWith(url, 'edl') }
    static isEDLAdmin = (url) => { return isStartsWith(url, 'edl/admin'); }
    static isEDLSupervisor = (url) => { return isStartsWith(url, 'edl/supervisor'); }
    static isEDLStaff = (url) => { return isStartsWith(url, 'edl/staff'); }
    //static isEDLCustomer = (url) => { return isStartsWith(url, 'edl/customer'); }

    //static isCustomer(url) { return UrlUtils.isStartsWith(url, 'customer') }
    static isAdmin = (url) => { return isStartsWith(url, 'customer/admin'); }
    static isExcuisive = (url) => { return isStartsWith(url, 'customer/exclusive'); }
    static isStaff = (url) => { return isStartsWith(url, 'customer/staff'); }

    static isDevice(url) { return UrlUtils.isStartsWith(url, 'rater') }
}

module.exports.UrlUtils = exports.UrlUtils = UrlUtils;
