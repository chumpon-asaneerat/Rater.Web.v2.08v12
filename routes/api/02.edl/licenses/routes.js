//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));
const secure = require(path.join(rootPath, 'edl', 'rater-secure')).RaterSecure;
const RaterStorage = require(path.join(rootPath, 'edl', 'rater-secure')).RaterStorage;

const dbutils = require(path.join(rootPath, 'edl', 'utils', 'db-utils')).DbUtils;
//const cookies = require(path.join(rootPath, 'edl', 'utils', 'cookie-utils')).CookieUtils;
//const urls = require(path.join(rootPath, 'edl', 'utils', 'url-utils')).UrlUtils;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//const fs = require('fs')
//const mkdirp = require('mkdirp')
//const sfs = require(path.join(rootPath, 'edl', 'server-fs'));

//#endregion

// static class.
const api = class { }

//#region Implement - Get

api.Get = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        /*
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        params.langId = null; // force null.
        params.branchId = null;
        params.enabled = true;
        */
        return params;
    }
    static async call(db, params) { 
        //return db.GetBranchs(params);
        return null;
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data);
        let result = {}        
        result.data = null
        //result.src = dbResult.data
        result.errors = dbResult.errors
        //result.multiple = dbResult.multiple
        //result.datasets = dbResult.datasets
        result.out = dbResult.out

        let records = dbResult.data;
        let ret = {};
        /*
        records.forEach(rec => {
            if (!ret[rec.langId]) {
                ret[rec.langId] = []
            }
            let map = ret[rec.langId].map(c => c.branchId);
            let idx = map.indexOf(rec.branchId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = {}
                nobj.branchId = rec.branchId
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.branchName = rec.BranchName;
        })
        */
        // set to result.
        result.data = ret;
        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.Get.prepare(req, res);
        let fn = async () => { return api.Get.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.Get.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}

//#endregion

//#region Implement - Save - not ued

// api.Save = class {
//     static prepare(req, res) {
//         let params = WebServer.parseReq(req).data;
//         /*
//         let storage = new RaterStorage(req, res)
//         let customerId = (storage.account) ? storage.account.customerId : null
//         if (customerId) params.customerId = customerId
//
//         params.langId = null; // force null.
//         params.branchId = null;
//         params.enabled = true;
//         */
//         return params;
//     }
//     static async call(db, params) { 
//         //return db.GetBranchs(params);
//         return null;
//     }
//     static parse(db, data, callback) {
//         let dbResult = dbutils.validate(db, data);
//         let result = {}        
//         result.data = null
//         //result.src = dbResult.data
//         result.errors = dbResult.errors
//         //result.multiple = dbResult.multiple
//         //result.datasets = dbResult.datasets
//         result.out = dbResult.out

//         let records = dbResult.data;
//         let ret = {};
//         /*
//         records.forEach(rec => {
//             if (!ret[rec.langId]) {
//                 ret[rec.langId] = []
//             }
//             let map = ret[rec.langId].map(c => c.branchId);
//             let idx = map.indexOf(rec.branchId);
//             let nobj;
//             if (idx === -1) {
//                 // set id
//                 nobj = {}
//                 nobj.branchId = rec.branchId
//                 // init lang properties list.
//                 ret[rec.langId].push(nobj)
//             }
//             else {
//                 nobj = ret[rec.langId][idx];
//             }
//             nobj.branchName = rec.BranchName;
//         })
//         */
//         // set to result.
//         result.data = ret;
//         callback(result);
//     }
//     static entry(req, res) {
//         let db = new sqldb();
//         let params = api.Save.prepare(req, res);
//         let fn = async () => { return api.Save.call(db, params); }
//         dbutils.exec(db, fn).then(data => {
//             api.Save.parse(db, data, (result) => {
//                 WebServer.sendJson(req, res, result);
//             });
//         })
//     }
// }

//#endregion

//#region Implement - Delete - not ued

// api.Delete = class {
//     static prepare(req, res) {
//         let params = WebServer.parseReq(req).data;
//         /*
//         let storage = new RaterStorage(req, res)
//         let customerId = (storage.account) ? storage.account.customerId : null
//         if (customerId) params.customerId = customerId
//
//         params.langId = null; // force null.
//         params.branchId = null;
//         params.enabled = true;
//         */
//         return params;
//     }
//     static async call(db, params) { 
//         //return db.GetBranchs(params);
//         return null;
//     }
//     static parse(db, data, callback) {
//         let dbResult = dbutils.validate(db, data);
//         let result = {}        
//         result.data = null
//         //result.src = dbResult.data
//         result.errors = dbResult.errors
//         //result.multiple = dbResult.multiple
//         //result.datasets = dbResult.datasets
//         result.out = dbResult.out

//         let records = dbResult.data;
//         let ret = {};
//         /*
//         records.forEach(rec => {
//             if (!ret[rec.langId]) {
//                 ret[rec.langId] = []
//             }
//             let map = ret[rec.langId].map(c => c.branchId);
//             let idx = map.indexOf(rec.branchId);
//             let nobj;
//             if (idx === -1) {
//                 // set id
//                 nobj = {}
//                 nobj.branchId = rec.branchId
//                 // init lang properties list.
//                 ret[rec.langId].push(nobj)
//             }
//             else {
//                 nobj = ret[rec.langId][idx];
//             }
//             nobj.branchName = rec.BranchName;
//         })
//         */
//         // set to result.
//         result.data = ret;
//         callback(result);
//     }
//     static entry(req, res) {
//         let db = new sqldb();
//         let params = api.Delete.prepare(req, res);
//         let fn = async () => { return api.Delete.call(db, params); }
//         dbutils.exec(db, fn).then(data => {
//             api.Delete.parse(db, data, (result) => {
//                 WebServer.sendJson(req, res, result);
//             });
//         })
//     }
// }

//#endregion

router.use(secure.checkAccess);
// routes for 
//router.all('/customer/search', api.Get.entry);
//router.all('/customer/save', api.Save.entry);
//router.all('/customer/delete', api.Delete.entry);

const init_routes = (svr) => {
    svr.route('/edl/api/', router);
};

module.exports.init_routes = exports.init_routes = init_routes;