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
    static entry(req, res) {
        let storage = new RaterStorage(req, res)
        /*        
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        let accessId = secure.getAccessId(req, res);
        if (accessId) params.accessId = accessId;

        let deviceId = secure.getDeviceId(req, res);
        if (deviceId) params.deviceId = deviceId;
        */
        let result = {
            data : {},
            errors: null,
            out: {}
        }
        if (storage.account) {
            result.data.customerId = storage.account.customerId
            result.data.deviceId = storage.account.deviceId
        }
        WebServer.sendJson(req, res, result);
    }
}

//#endregion

//#region Implement - Save

api.Save = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        let accessId = secure.getAccessId(req, res);
        if (accessId) params.accessId = accessId;
        // required value or null but required
        //params.deviceId = null; // reset

        return params;
    }
    static async call(db, params) { 
        let ret = db.SetAccessDevice(params);
        return ret;
    }
    static parse(db, data, callback) {
        let result = dbutils.validate(db, data);
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

router.use(secure.checkAccess);
// routes for device
router.all('/rating/device', api.Get.entry);
router.post('/rating/device/save', api.Save.entry);

const init_routes = (svr) => {
    svr.route('/customer/api/', router);
};

module.exports.init_routes = exports.init_routes = init_routes;