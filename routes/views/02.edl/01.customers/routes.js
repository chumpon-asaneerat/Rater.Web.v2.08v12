//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const sfs = require(path.join(rootPath, 'edl', 'server-fs'));
const secure = require(path.join(rootPath, 'edl', 'rater-secure')).RaterSecure;

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

//#region api

const routes = class {
    static home(req, res) {
        WebServer.sendFile(req, res, __dirname, 'html', 'index.html');
    }
    static getjsfile(req, res) {
        let file = req.params.file.toLowerCase();
        let files = ['app.js']
        let idx = files.indexOf(file);
        if (idx !== -1) {
            let fname = path.join(__dirname, 'js', files[idx]);
            WebServer.sendFile(req, res, fname);
        }
    }
    static getContents(req, res) {
        let data = sfs.getContents(path.join(__dirname, 'contents'));
        let result = nlib.NResult.data(data);
        WebServer.sendJson(req, res, result);
    }
}

//#endregion

router.get('/', secure.checkAccess, secure.checkRedirect, routes.home)
//router.get('/', secure.checkAccess, secure.checkRedirect, routes.home)
router.get('/contents', routes.getContents)
router.get('/js/:file', routes.getjsfile)

const init_routes = (svr) => {
    svr.route('/edl/customer', router);
};

// required
// need to add SP EDLSignin
// need to add access customer by Id route.
/*
const init_routes = (svr) => {
    svr.route('/edl/customer/:customerId', router);
};
*/


module.exports.init_routes = exports.init_routes = init_routes;