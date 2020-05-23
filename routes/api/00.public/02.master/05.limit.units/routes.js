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

//#region Implement - GetLimitUnits

api.GetLimitUnits = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId = 'EN' // not exists so assign EN.
        params.enabled = true
        return params
    }
    static async call(db, params) { 
        return db.GetLimitUnits(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'limitUnitId', (nobj, record) => {
            nobj.Description = record.LimitUnitDescription
            nobj.Text = record.LimitUnitText
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetLimitUnits
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

//#region Implement - GetLimitUnit

api.GetLimitUnit = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.langId = null // force assign enable language only.
        // read id from request object.
        let id = 'limitUnitId'
        params[id] = (req.params.id) ? req.params.id : params[id]
        params.enabled = true // force assign enable language only.
        return params
    }
    static async call(db, params) { 
        return db.GetLimitUnit(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'limitUnitId', (nobj, record) => {
            nobj.Description = record.LimitUnitDescription
            nobj.Text = record.LimitUnitText
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetLimitUnit
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

router.all('/limitunits', api.GetLimitUnits.entry)
router.get('/limitunits/search/:id', api.GetLimitUnit.entry)
router.post('/limitunits/search', api.GetLimitUnit.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;