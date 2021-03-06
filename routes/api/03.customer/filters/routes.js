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
api.filter = class {}

api.filter.FilterVoteOrgs = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        /* 
        TODO: Language Id is required to assigned every time the UI Language change.
        TODO: Stored procedure checking required.
        */
        // force langId to null;
        params.langId = null;

        return params;
    }
    static async call(db, params) {
        return db.FilterVoteOrgs(params);
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data);

        let result = {
            data : null,
            //src: dbResult.data,
            errors: dbResult.errors,
            //multiple: dbResult.multiple,
            //datasets: dbResult.datasets,
            out: dbResult.out
        }
        let records = dbResult.data;
        let ret = {};

        records.forEach(rec => {
            if (!ret[rec.langId]) {
                ret[rec.langId] = []
            }
            let map = ret[rec.langId].map(c => c.orgId);
            let idx = map.indexOf(rec.orgId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { orgId: rec.orgId }
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.customerId = rec.customerId;
            nobj.OrgName = rec.OrgName;
            nobj.branchId = rec.BranchId;
            nobj.BranchName = rec.BranchName;
        })
        // set to result.
        result.data = ret;

        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.filter.FilterVoteOrgs.prepare(req, res);
        let fn = async () => { return api.filter.FilterVoteOrgs.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.filter.FilterVoteOrgs.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}
api.filter.FilterVoteMembers = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        // force langId to null;
        params.langId = null;

        return params;
    }
    static async call(db, params) {
        return db.FilterVoteMembers(params);
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data);

        let result = {
            data : null,
            //src: dbResult.data,
            errors: dbResult.errors,
            //multiple: dbResult.multiple,
            //datasets: dbResult.datasets,
            out: dbResult.out
        }
        let records = dbResult.data;
        let ret = {};

        records.forEach(rec => {
            if (!ret[rec.langId]) {
                ret[rec.langId] = []
            }
            let map = ret[rec.langId].map(c => c.memberId);
            let idx = map.indexOf(rec.UserId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { memberId: rec.UserId }
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            //nobj.customerId = rec.customerId;
            //nobj.OrgName = rec.OrgName;
            //nobj.branchId = rec.BranchId;
            //nobj.BranchName = rec.BranchName;
            //nobj.memberId = rec.UserId;
            nobj.FullName = rec.FullName;
        })
        // set to result.
        result.data = ret;

        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.filter.FilterVoteMembers.prepare(req, res);
        let fn = async () => { return api.filter.FilterVoteMembers.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.filter.FilterVoteMembers.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}
api.filter.QSetByDate = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId
        
        // force langId to null;
        params.langId = null;

        return params;
    }
    static async call(db, params) {
        return db.GetQSetByDate(params);
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data);

        let result = {
            data : null,
            //src: dbResult.data,
            errors: dbResult.errors,
            //multiple: dbResult.multiple,
            //datasets: dbResult.datasets,
            out: dbResult.out
        }
        let records = dbResult.data;
        let ret = {};

        records.forEach(rec => {
            if (!ret[rec.langId]) {
                ret[rec.langId] = []
            }
            let map = ret[rec.langId].map(c => c.qSetId);
            let idx = map.indexOf(rec.qSetId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { qSetId: rec.qSetId }
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.BeginDate = rec.BeginDate;
            nobj.EndDate = rec.EndDate;
            nobj.minVoteDate = rec.MinVoteDate;
            nobj.maxVoteDate = rec.MaxVoteDate;
            nobj.desc = rec.Description;
        })
        // set to result.
        result.data = ret;

        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.filter.QSetByDate.prepare(req, res);
        let fn = async () => { return api.filter.QSetByDate.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.filter.QSetByDate.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}

router.use(secure.checkAccess);
// routes for staff summaries
router.all('/vote-orgs', api.filter.FilterVoteOrgs.entry);
router.all('/vote-members', api.filter.FilterVoteMembers.entry);
router.all('/qsetbydate', api.filter.QSetByDate.entry);

const init_routes = (svr) => {
    svr.route('/customers/api/filters', router);
};

module.exports.init_routes = exports.init_routes = init_routes;