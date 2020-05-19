//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
const sfs = require(path.join(rootPath, 'edl', 'server-fs'));
//const secure = require(path.join(rootPath, 'edl', 'rater-secure')).RaterSecure;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

const routes = class {
    /**
     * home
     * @param {Request} req The Request.
     * @param {Response} res The Response.
     */
    static home(req, res) {
        WebServer.sendFile(req, res, __dirname, 'index.html');
    }
    static getCss(req, res) {
        WebServer.sendFile(req, res, __dirname, 'style.css');
    }
    static getScriptJs(req, res) {
        WebServer.sendFile(req, res, __dirname, 'script.js');
    }
    static getFabricJs(req, res) {
        WebServer.sendFile(req, res, __dirname, 'fabric-ex.js');
    }
}

router.get('/es6', routes.home)
router.get('/es6/style.css', routes.getCss)
router.get('/es6/script.js', routes.getScriptJs)
router.get('/es6/fabric-ex.js', routes.getFabricJs)

const init_routes = (svr) => {
    svr.route('/dev/fabricjs', router);
};

module.exports.init_routes = exports.init_routes = init_routes;
