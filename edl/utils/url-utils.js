const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));

//#region requset url parser methods

const getFullUrl = (req) => {
    return req.protocol + '://' + req.get('hostname') + req.originalUrl;
}
const getRoutePath = (req) => {
    let url = UrlUtils.getFullUrl(req);
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

//#endregion

//#region Home route

const isHome = (url) => {
    let lsrc = url.toLowerCase();
    if (lsrc.charAt(0) === '/') lsrc = lsrc.substring(1); // remove slash
    let ret = (lsrc.length === 0);
    return ret;
}
const gotoHome = (req, res, next, url) => {
    if (!isHome(url)) res.redirect('/')
    else {
        if (next) next()
    }
}

//#endregion


// Implements note:
// In edl/customer
// - Implements method to check member type to access each route not depend to url
//   for example report route should seen when current user is admin or exclusive
//   but url need to be the same so all gotoXXX middleware method required to 
//   re-implements for proper check by member type instead of the url itself.


//#region EDL routes

const isEDLAdmin = (url) => { return isStartsWith(url, 'edl/admin'); }
const gotoEDLAdmin = (req, res, next, url) => {
    if (!isEDLAdmin(url)) {
        res.redirect('/edl/admin')
    }
    else {
        if (next) next()
    }
}
const isEDLSupervisor = (url) => { return isStartsWith(url, 'edl/supervisor'); }
const gotoEDLSupervisor = (req, res, next, url) => {
    if (!isEDLSupervisor(url)) {
        res.redirect('/edl/supervisor')
    }
    else {
        if (next) next()
    }
}
const isEDLStaff = (url) => { return isStartsWith(url, 'edl/staff'); }
const gotoEDLStaff = (req, res, next, url) => {
    if (!isEDLStaff(url)) {
        res.redirect('/edl/staff')
    }
    else {
        if (next) next()
    }
}

//#endregion

//#region customer routes

const isAdmin = (url) => { return isStartsWith(url, 'customer/admin'); }
const gotoAdmin = (req, res, next, url) => {
    if (!isAdmin(url)) {
        res.redirect('/customer/admin')
    }
    else {
        if (next) next()
    }
}
const isExcuisive = (url) => { return isStartsWith(url, 'customer/exclusive'); }
const gotoExcuisive = (req, res, next, url) => {
    if (!isExcuisive(url)) {
        res.redirect('/customer/exclusive')
    }
    else {
        if (next) next()
    }
}
const isStaff = (url) => { return isStartsWith(url, 'customer/staff'); }
const gotoStaff = (req, res, next, url) => {
    if (!isStaff(url)) {
        res.redirect('/customer/staff')
    }
    else {
        if (next) next()
    }
}

//#endregion

//#region rater (device) routes

const isDevice = (url) => { return UrlUtils.isStartsWith(url, 'rater') }
const gotoDevice = (req, res, next, url) => {
    if (!isStaff(url)) {
        res.redirect('/rater')
    }
    else {
        if (next) next()
    }
}

//#endregion

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

class UrlUtils {
    static getFullUrl(req) { return getFullUrl(req) }
    static getRoutePath(req) { return getRoutePath(req) }
    static goHome(memberType) { return goHome(memberType) }
}

module.exports.UrlUtils = exports.UrlUtils = UrlUtils;
