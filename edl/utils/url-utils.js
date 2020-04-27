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
const removeEndSlash = (sPath) => {
    let lpath = sPath.toLowerCase();
    if (lpath.charAt(0) === '/') lpath = lpath.substring(1); // remove slash
    return lpath;
}
/*
const isStartsWith = (src, sPath) => {
    let lsrc = removeEndSlash(src)
    let lpath = removeEndSlash(sPath);
    let ret = lsrc.startsWith(lpath);
    return ret;
}
*/
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

//#region EDL routes

// EDL Admin
const edlAdminUrls = [
    // home
    'edl/admin'
]
const isEDLAdminRoute = (url) => {
    let urls = edlAdminUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoEDLAdmin = (req, res, next, url) => {
    if (!isEDLAdminRoute(url)) {
        res.redirect('/edl/admin')
    }
    else {
        if (next) next()
    }
}
// EDL Supervisor
const edlSupervisorUrls = [
    // home
    'edl/supervisor'
]
const isEDLSupervisorRoute = (url) => {
    let urls = edlSupervisorUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoEDLSupervisor = (req, res, next, url) => {
    if (!isEDLSupervisorRoute(url)) {
        res.redirect('/edl/supervisor')
    }
    else {
        if (next) next()
    }
}
// EDL Staff
const edlStaffUrls = [
    // home
    'edl/staff'
]
const isEDLStaffRoute = (url) => {
    let urls = edlStaffUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoEDLStaff = (req, res, next, url) => {
    if (!isEDLStaffRoute(url)) {
        res.redirect('/edl/staff')
    }
    else {
        if (next) next()
    }
}

//#endregion

//#region customer routes

const adminUrls = [
    // member edit
    'customer/member/edit',
    // member view
    'customer/member',
    // device edit
    'customer/device/edit',
    // device
    'customer/device',
    // branch edit
    'customer/branch/edit',
    // branch
    'customer/branch',
    // org edit
    'customer/org/edit',
    // org
    'customer/org',
    // report home
    'customer/report',
    // report raw vote
    'customer/report/rawvote',
    // report vote summary
    'customer/report/votesummary',
    // report bar chart
    'customer/report/barchart',
    // report pie chart
    'customer/report/piechart',
    // report staff compare
    'customer/report/staffcompare',
    // report staff performance
    'customer/report/staffperf',
    // home
    'customer/admin'
]
const isAdminRoute = (url) => {
    let urls = adminUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoAdmin = (req, res, next, url) => {
    if (!isAdminRoute(url)) {
        res.redirect('/customer/admin')
    }
    else {
        if (next) next()
    }
}
const exclusiveUrls = [
    // member edit
    'customer/member/edit',
    // member
    'customer/member',
    // report home
    'customer/report',
    // report raw vote
    'customer/report/rawvote',
    // report vote summary
    'customer/report/votesummary',
    // report bar chart
    'customer/report/barchart',
    // report pie chart
    'customer/report/piechart',
    // report staff compare
    'customer/report/staffcompare',
    // report staff performance
    'customer/report/staffperf',
    // home
    'customer/exclusive'
]
const isExcuisiveRoute = (url) => {
    let urls = exclusiveUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoExcuisive = (req, res, next, url) => {
    if (!isExcuisiveRoute(url)) {
        res.redirect('/customer/exclusive')
    }
    else {
        if (next) next()
    }
}
const staffUrls = [
    // member edit (self)
    'customer/member/edit',
    // home
    'customer/staff'
]
const isStaffRoute = (url) => {
    let urls = staffUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoStaff = (req, res, next, url) => {
    if (!isStaffRoute(url)) {
        res.redirect('/customer/staff')
    }
    else {
        if (next) next()
    }
}

//#endregion

//#region rater (device) routes

const deviceUrls = [
    // setup customer's device
    'rater/register',
    // setup customer's org for device
    'rater/setup',
    // device user signin
    'rater/signin',
    // device question
    'rater/question',
    // home
    'rater'
]
const isDeviceRoute = (url) => {
    let urls = deviceUrls
    let idx = urls.indexOf(removeEndSlash(url))
    return (idx !== -1)
}
const gotoDevice = (req, res, next, url) => {
    if (!isDeviceRoute(url)) {
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
    static isDeviceRoute(url) { return isDeviceRoute(url) }
}

module.exports.UrlUtils = exports.UrlUtils = UrlUtils;
