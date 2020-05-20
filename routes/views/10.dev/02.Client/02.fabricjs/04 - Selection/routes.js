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
    static home(req, res) {
        WebServer.sendFile(req, res, __dirname, 'html', 'index.html');
    }
    static getcssfile(req, res) {
        let file = req.params.file.toLowerCase();
        let files = ['style.css']
        let idx = files.indexOf(file);
        if (idx !== -1) {
            let fname = path.join(__dirname, 'css', files[idx]);
            WebServer.sendFile(req, res, fname);
        }
    }
    static getjsfile(req, res) {
        let file = req.params.file.toLowerCase();
        let files = ['app.js', 'script.js', 'nlib-fabric.js']
        let idx = files.indexOf(file);
        if (idx !== -1) {
            let fname = path.join(__dirname, 'js', files[idx]);
            WebServer.sendFile(req, res, fname);
        }
    }
    static getAssetList(req, res) {
        let obj = { urls: [] }
        WebServer.sendJson(req, res, obj)
    }
    static getAsset(req, res) {
        console.log(req)
        let obj = { urls: [] }
        WebServer.sendJson(req, rest, obj)
    }
}

router.get('/', routes.home)
router.get('/css/:file', routes.getcssfile)
router.get('/js/:file', routes.getjsfile)

const init_routes = (svr) => {
    svr.route('/dev/fabricjs/selection', router);
};

module.exports.init_routes = exports.init_routes = init_routes;
