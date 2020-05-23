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

//#region Implement - GetLicenseTypes

api.GetLicenseTypes = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId = null // not exists so assign null.
        params.enabled = true
        return params
    }
    static async call(db, params) { 
        return db.GetLicenseTypes(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'licenseTypeId', (nobj, record) => {
            nobj.type = record.Type
            nobj.Description = record.LicenseTypeDescription
            nobj.AdText = record.AdText
            nobj.periodUnitId = record.periodUnitId
            nobj.NoOfUnit = record.NoOfUnit
            nobj.UseDefaultPrice = record.UseDefaultPrice
            nobj.Price = record.Price
            nobj.CurrencySymbol = record.CurrencySymbol
            nobj.CurrencyText = record.CurrencyText
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetLicenseTypes
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

router.all('/licensetypes', api.GetLicenseTypes.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;