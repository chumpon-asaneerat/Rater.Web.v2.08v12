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

const api = class {}

//#region Implement - Get

api.Get = class {
    static prepare(req, res) {
       let params = WebServer.parseReq(req).data;
       if (params.langId === undefined || params.langId === null || params.langId === '') {
           params.langId = null;
       }
       let storage = new RaterStorage(req, res)
       let customerId = (storage.account) ? storage.account.customerId : null
       if (customerId) params.customerId = customerId

       params.deviceId = null;
       params.userId = null;

        return params;
    }
    static async call(db, params) { 
        //return await api.question.load(db, params);
        let oParams = {};
        oParams.langId = params.langId;
        oParams.customerId = params.customerId;
        oParams.beginDate = params.beginDate;
        oParams.endDate = params.endDate;
        oParams.qsetId = params.qsetId;

        let qset = await api.GetQSet(db, params);

        let slides = params.slides;
        let orgs = params.orgs;
        let ret, dbresult;
        let result = {};
        // loop selected slide
        if (slides && slides.length > 0) {
            for (let i = 0; i < slides.length; i++) {
                oParams.qSeq = slides[i].qSeq;
                if (orgs && orgs.length > 0) {
                    for (let j = 0; j < orgs.length; j++) {
                        oParams.orgId = orgs[j].orgId;
                        // execute
                        ret = await db.GetVoteSummaries(oParams);
                        dbresult = dbutils.validate(db, ret);
                        api.CreateVoteSummaries(result, qset, dbresult.data)
                    }
                }
                else {
                    // no org specificed
                    oParams.orgId = null;
                    // execute
                    ret = await db.GetVoteSummaries(oParams);
                    dbresult = dbutils.validate(db, ret);
                    api.CreateVoteSummaries(result, qset, dbresult.data)
                }
            }
        }
        else {
            // no slide specificed
            oParams.qSeq = null;
            if (orgs && orgs.length > 0) {
                for (let j = 0; j < orgs.length; j++) {
                    oParams.orgId = orgs[j].orgId;
                    // execute
                    ret = await db.GetVoteSummaries(oParams);
                    dbresult = dbutils.validate(db, ret);
                    api.CreateVoteSummaries(result, qset, dbresult.data)
                }
            }
            else {
                // no org specificed
                oParams.orgId = null;
                // execute
                ret = await db.GetVoteSummaries(oParams);
                dbresult = dbutils.validate(db, ret);
                api.CreateVoteSummaries(result, qset, dbresult.data)
            }
        }

        //return db.GetVoteSummaries(params);
        return result;
    }
    static parse(db, data, callback) {
        //let result = api.question.parse(db, params, data)
        let result = {
            data: null,
            errors: {
                hasError: false,
                errNum: 0,
                errMsg: ''
            },
            out: {}
        }
        // set to result.
        result.data = data;
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

//#region Implement - Save

api.Save = class {
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

        // set to result.
        result.data = ret;

        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.Save.prepare(req, res);
        let fn = async () => { return api.Save.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.Save.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}

//#endregion

//#region Implement - Delete

api.Delete = class {
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

        // set to result.
        result.data = ret;

        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.Delete.prepare(req, res);
        let fn = async () => { return api.Delete.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.Delete.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}

//#endregion

router.use(secure.checkAccess);
// same as rawvote
router.all('/', api.Get.entry);
router.all('/save', api.Save.entry);
//router.all('/report/vote/delete', api.Delete.entry);

const init_routes = (svr) => {
    svr.route('/customer/api//votes', router);
};

module.exports.init_routes = exports.init_routes = init_routes;