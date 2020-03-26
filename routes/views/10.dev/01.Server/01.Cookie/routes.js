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
        let fname = path.join(__dirname, 'index.html')
        
        let obj = {
            secure: {
                mode: 'edl',
                edl: {
                    accessId: '11'
                },
                customer: {
                    accessId: '22'
                },
                device: {
                    accessId: '3'
                },
            }
        }
        //WebServer.signedCookie.writeObject(req, res, obj, WebServer.expires.in(5).years);
        WebServer.cookie.writeObject(req, res, obj, WebServer.expires.in(5).years, false);

        WebServer.sendFile(req, res, fname)
    }
    static getcssfile(req, res) {
        let file = req.params.file.toLowerCase()
        let files = ['style.css']
        let idx = files.indexOf(file)
        if (idx !== -1) {
            let fname = path.join(__dirname, 'css', files[idx])
            WebServer.sendFile(req, res, fname)
        }
    }
    static getjsfile(req, res) {
        let file = req.params.file.toLowerCase()
        let files = ['app.js']
        let idx = files.indexOf(file)
        if (idx !== -1) {
            let fname = path.join(__dirname, 'js', files[idx])
            WebServer.sendFile(req, res, fname)
        }
    }
}

router.get('/', routes.home)
router.get('/css/:file', routes.getcssfile)
router.get('/js/:file', routes.getjsfile)

const init_routes = (svr) => {
    svr.route('/dev/server/cookie', router);
};

module.exports.init_routes = exports.init_routes = init_routes;