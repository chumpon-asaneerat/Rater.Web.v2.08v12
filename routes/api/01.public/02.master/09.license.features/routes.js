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
        params.langId = null; // force langId to null;
        params.licenseTypeId = null;

        return params;
    }
    static async call(db, params) { 
        return db.GetLicenseFeatures(params);
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
            let map = ret[rec.langId].map(c => c.licenseTypeId);
            let idx = map.indexOf(rec.licenseTypeId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { licenseTypeId: rec.licenseTypeId }
                nobj.items = [];
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }

            let seqs = nobj.items.map(item => item.seq);
            let idx2 = seqs.indexOf(rec.seq);
            let nobj2;
            if (idx2 === -1) {
                nobj2 = {
                    seq: rec.seq
                }
                nobj.items.push(nobj2);
            }
            else {
                nobj2 = seqs[idx2];
            }                
            nobj2.limitUnitId = rec.limitUnitId;
            nobj2.NoOfLimit = rec.NoOfLimit;
            nobj2.UnitDescription = rec.LimitUnitDescription;
            nobj2.UnitText = rec.LimitUnitText;
        })
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

router.all('/licensefeatures', api.Get.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;