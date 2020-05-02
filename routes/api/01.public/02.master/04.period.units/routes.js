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

//#region Implement - GetPeriodUnits

api.GetPeriodUnits = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId = null // not exists so assign null.
        params.enabled = true
        return params
    }
    static async call(db, params) { 
        return db.GetPeriodUnits(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)

        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        let records = dbResult.data;
        let ret = {};

        records.forEach(rec => {
            if (!ret[rec.langId]) {
                ret[rec.langId] = []
            }
            // Ignore check id.
            let nobj = { 
                periodUnitId: rec.periodUnitId, 
                Description: rec.PeriodUnitDescription
            }
            ret[rec.langId].push(nobj)

            // Original code.
            /*
            let map = ret[rec.langId].map(c => c.periodUnitId);
            let idx = map.indexOf(rec.periodUnitId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { periodUnitId: rec.periodUnitId }
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.Description = rec.PeriodUnitDescription;
            */
        })
        // set to result.
        result.data = ret;

        callback(result)
    }
    static entry(req, res) {
        let ref = api.GetPeriodUnits
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

router.all('/periodunits', api.GetPeriodUnits.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;