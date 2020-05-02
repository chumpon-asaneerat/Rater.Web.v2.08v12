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

//#region Implement - GetLicenseFeatures

api.GetLicenseFeatures = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId = 'EN' // not exists so assign EN.
        if (!params.licenseTypeId) params.licenseTypeId = null // not exists so assigned null.
        return params
    }
    static async call(db, params) { 
        return db.GetLicenseFeatures(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        result.data = dbutils.buildTree2(dbResult, 'licenseTypeId', 'seq', (nobj, record) => {
            nobj.seq = record.seq
            nobj.limitUnitId = record.limitUnitId
            nobj.NoOfLimit = record.NoOfLimit
            nobj.UnitDescription = record.LimitUnitDescription
            nobj.UnitText = record.LimitUnitText
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetLicenseFeatures
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

router.all('/licensefeatures', api.GetLicenseFeatures.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;