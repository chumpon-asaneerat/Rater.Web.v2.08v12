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

//#endregion

const api = class {}

//#region Implement - Get

api.Get = class {
    static prepare(req, res) {
       let params = WebServer.parseReq(req).data;
       rptAPI.question.checkLanguageId(params)
       let customerId = secure.getCustomerId(req, res);
       if (customerId) params.customerId = customerId;

        return params;
    }
    static async call(db, params) { 
        return await rptAPI.staffcompare.load(db, params);
    }
    static parse(db, data, callback) {
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
        exec(db, fn).then(data => {
            api.Get.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}

//#endregion

router.use(secure.checkAccess);
// routes for staff summaries
router.all('/report/staffcompare/search', api.Get.entry);

const init_routes = (svr) => {
    svr.route('/customer/api/', router);
};

module.exports.init_routes = exports.init_routes = init_routes;