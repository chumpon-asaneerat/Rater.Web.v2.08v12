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

//#region Implement - GetMemberTypes

api.GetMemberTypes = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId =  'EN' // not exists so assign EN.
        params.enabled = true
        return params
    }
    static async call(db, params) { 
        return db.GetMemberTypes(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'memberTypeId', (nobj, record) => {
            nobj.Description = record.MemberTypeDescription
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetMemberTypes
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result)
            });
        })
    }
}

//#endregion

//#region Implement - GetMemberType

api.GetMemberType = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId =  'EN' // not exists so assign EN.
        params.enabled = true
        // read id from request object.
        params.memberTypeId = (req.params.id) ? req.params.id : null
        return params
    }
    static async call(db, params) { 
        return db.GetMemberType(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'memberTypeId', (nobj, record) => {
            nobj.Description = record.MemberTypeDescription
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetMemberType
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result)
            });
        })
    }
}

//#endregion

router.all('/membertypes', api.GetMemberTypes.entry)
router.all('/membertypes/:id', api.GetMemberType.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;