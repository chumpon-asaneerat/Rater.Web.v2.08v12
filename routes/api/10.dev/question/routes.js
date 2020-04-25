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

const fs = require('fs')
const mkdirp = require('mkdirp')
//const sfs = require(path.join(rootPath, 'edl', 'server-fs'));

//#endregion

const routes = class {
    static SaveJsonQuestion(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        params.customerId = 'EDL-2019100001' // hard code.
        params.qsetid = 'QS00001' // hard code.
        let targetPath = path.join(rootPath, 'customer', params.customerId, 'Question')
        mkdirp.sync(targetPath);
        let targetFile =  path.join(targetPath, params.qsetid + '.json')
        let data = {
            id: params.qsetid,
            data: params.data
        };
        fs.writeFileSync(targetFile, JSON.stringify(data), 'utf8')

        let result = nlib.NResult.data({});
        WebServer.sendJson(req, res, result);
    }
    static LoadJsonQuestion(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        params.customerId = 'EDL-2019100001' // hard code.
        params.qsetid = 'QS00001' // hard code.
        let targetPath = path.join(rootPath, 'customer', params.customerId, 'Question')
        let obj = null;
        let targetFile =  path.join(targetPath, params.qsetid + '.json')
        if (fs.existsSync(targetFile)) {
            obj = fs.readFileSync(targetFile, 'utf8')
        }
        let result = (obj) ? nlib.NResult.data(obj) : nlib.NResult.error(-300, 'file not found');
        WebServer.sendJson(req, res, result);
    }
}

//router.use(secure.checkAccess);

router.post('/question/save', routes.SaveJsonQuestion);
router.post('/question/load', routes.LoadJsonQuestion);

const init_routes = (svr) => {
    svr.route('/dev/api/', router);
};

module.exports.init_routes = exports.init_routes = init_routes;