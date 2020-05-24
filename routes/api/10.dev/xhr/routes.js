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
const sfs = require(path.join(rootPath, 'edl', 'server-fs'));

//#endregion

const api = class {
    static upload(req, res) {
        let result = {
            message: 'upload'
        }
        WebServer.sendJson(req, res, result);
    }
    static download(req, res) {
        let result = {
            message: 'download'
        }
        WebServer.sendJson(req, res, result);
    }
}

router.all('/upload', api.upload);
router.all('/download', api.download);

const init_routes = (svr) => {
    svr.route('/dev/api/xhr', router);
};

module.exports.init_routes = exports.init_routes = init_routes;