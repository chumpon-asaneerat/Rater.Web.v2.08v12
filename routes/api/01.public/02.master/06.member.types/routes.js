//#region requires

const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));

const sfs = require(path.join(rootPath, 'edl', 'server-fs'));
const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r9.db'));

const WebServer = require(path.join(rootPath, 'nlib', 'nlib-express'));
const WebRouter = WebServer.WebRouter;
const router = new WebRouter();

//#endregion

//#region exec/validate wrapper method

const exec = async (db, callback) => {
    let ret;
    let connected = await db.connect();
    if (connected) {
        ret = await callback();
        await db.disconnect();
    }
    else {
        ret = db.error(db.errorNumbers.CONNECT_ERROR, 'No database connection.');
    }
    return ret;
}
const validate = (db, data) => {
    let result = data;
    if (!result) {
        result = db.error(db.errorNumbers.NO_DATA_ERROR, 'No data returns');
    }
    else {
        result = checkForError(data);
    }
    return result;
}
const checkForError = (data) => {
    let result = data;
    if (result.out && result.out.errNum && result.out.errNum !== 0) {
        result.errors.hasError = true;
        result.errors.errNum = result.out.errNum;
        result.errors.errMsg = result.out.errMsg;
    }
    return result;
}

//#endregion

// static class.
const api = class { }

//#region Implement - Get

api.Get = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        // force langId to null;
        params.langId = null;
        params.enabled = true;

        return params;
    }
    static async call(db, params) { 
        return db.GetMemberTypes(params);
    }
    static parse(db, data, callback) {
        let dbResult = validate(db, data);

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
            let map = ret[rec.langId].map(c => c.memberTypeId);
            let idx = map.indexOf(rec.memberTypeId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { memberTypeId: rec.memberTypeId }
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.Description = rec.MemberTypeDescription;
        })
        // set to result.
        result.data = ret;

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

router.all('/membertypes', api.Get.entry)

const init_routes = (svr) => {
    svr.route('/api', router);
};

module.exports.init_routes = exports.init_routes = init_routes;