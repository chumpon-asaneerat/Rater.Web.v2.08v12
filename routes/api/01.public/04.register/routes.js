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

const routes = class {
    static register(req, res) {
        let db = new sqldb();
        let params = WebServer.parseReq(req).data;
        let fn = async () => {
            return db.Register(params);
        }
        dbutils.exec(db, fn).then(data => {
            let result = dbutils.validate(db, data);
            WebServer.sendJson(req, res, result);
        })
    }
    static CheckUsers(req, res) {
        let db = new sqldb();
        let params = WebServer.parseReq(req).data;
        params.langId = null
        
        let fn = async () => {
            return db.CheckUsers(params);
        }
        dbutils.exec(db, fn).then(data => {
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
                let map = ret[rec.langId].map(c => c.customerId);
                let idx = map.indexOf(rec.customerId);
                let nobj;
                if (idx === -1) {
                    // set id
                    nobj = { customerId: rec.customerId }
                    // init lang properties list.
                    ret[rec.langId].push(nobj)
                }
                else {
                    nobj = ret[rec.langId][idx];
                }
                nobj.FullName = rec.FullName;
                nobj.CustomerName = rec.CustomerName;
                nobj.IsEDLUser = rec.IsEDLUser;
            })
            // set to result.
            result.data = ret;

            WebServer.sendJson(req, res, result);
        })
    }
}

router.post('/register', routes.register)
router.post('/validate-accounts', routes.CheckUsers)

router.post('/signin', secure.clientSignIn)
router.post('/signout', secure.clientSignOut)
//router.post('/change-customer', secure.changeCustomer)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;
