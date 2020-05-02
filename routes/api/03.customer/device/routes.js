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

//#region Implement - GetDevices

api.GetDevices = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        if (!params.langId) params.langId = 'EN' // not exists so assign EN.
        // replace customer id from cookie if exists
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId
        params.enabled = true
        return params
    }
    static async call(db, params) { 
        return db.GetDevices(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'deviceId', (nobj, record) => {
            nobj.DeviceName = record.DeviceName
            nobj.Location = record.Location
            nobj.deviceTypeId = record.deviceTypeId
            nobj.memberId = record.memberId
            nobj.orgId = record.orgId
            nobj.Type = record.Type
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetDevices
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result)
            });
        })
    }
}

//#endregion

//#region Implement - GetDevice

api.GetDevice = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data
        params.langId = null // force assign null.
        // replace customer id from cookie if exists
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId
        // read id from request object.
        let id = 'deviceId'
        params[id] = (req.params.id) ? req.params.id : params[id]
        params.enabled = true // force assign enable language only.
        return params
    }
    static async call(db, params) { 
        return db.GetDevice(params)
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data)
        let result = {
            data : null,
            errors: dbResult.errors,
            out: dbResult.out
        }
        // set to result.
        result.data = dbutils.buildTree(dbResult, 'deviceId', (nobj, record) => {
            nobj.DeviceName = record.DeviceName
            nobj.Location = record.Location
            nobj.deviceTypeId = record.deviceTypeId
            nobj.memberId = record.memberId
            nobj.orgId = record.orgId
            nobj.Type = record.Type
        })
        // execute callback
        if (callback) callback(result)
    }
    static entry(req, res) {
        let ref = api.GetDevice
        let db = new sqldb()
        let params = ref.prepare(req, res)
        let fn = async () => { return ref.call(db, params) }
        dbutils.exec(db, fn).then(data => {
            ref.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result)
            });
        })
    }
}

//#endregion

//#region Implement - Get

api.Get = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId

        /* 
        TODO: Language Id is required to assigned every time the UI Language change.
        TODO: Parameter checks required.
        TODO: The get one stored proecdure need to implements new route.
        */
        // force langId to null;
        params.langId = null;
        params.deviceId = null;
        params.enabled = true;

        return params;
    }
    static async call(db, params) { 
        return db.GetDevices(params);
    }
    static parse(db, data, callback) {
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
            let map = ret[rec.langId].map(c => c.deviceId);
            let idx = map.indexOf(rec.deviceId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = { deviceId: rec.deviceId }
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.DeviceName = rec.DeviceName;
            nobj.Location = rec.Location;
            nobj.deviceTypeId = rec.deviceTypeId;
            nobj.memberId = rec.memberId;
            nobj.orgId = rec.orgId;
            nobj.Type = rec.Type;
        })
        // set to result.
        result.data = ret;

        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.Get.prepare(req, res);
        let fn = async () => { return api.Get.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.Get.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
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

        return params;
    }
    static async call(db, params) { 
        let ret;
        let rets = [];
        let customerId = params.customerId;
        if (params && params.items) {
            let items = params.items;
            let deviceId;
            // loop to save EN item as default and 
            // keep device id when create new.
            for (let i = 0; i < items.length; i++) {
                let item = items[i];
                item.customerId = customerId;
                if (item.langId === 'EN') {
                    ret = await db.SaveDevice(item);
                    deviceId = ret.out.deviceId;
                    rets.push(ret);
                }
            }
            // loop to save non EN items and 
            // assign parent device id when save in child table.
            for (let i = 0; i < items.length; i++) {
                let item = items[i];
                item.customerId = params.customerId;
                if (!item.deviceId || item.deviceId === '') {
                    item.deviceId = deviceId;
                }                
                if (item.langId !== 'EN') {
                    ret = await db.SaveDeviceML(item);
                    rets.push(ret);
                }                
            }
        }
        return rets;
    }
    static parse(db, data, callback) {
        let results = [];
        let result;
        let dbResult;

        for (let i = 0; i < data.length; i++) {
            dbResult = dbutils.validate(db, data[i]);

            result = {
                data : dbResult.data,
                //src: dbResult.data,
                errors: dbResult.errors,
                //multiple: dbResult.multiple,
                //datasets: dbResult.datasets,
                out: dbResult.out
            }
            results.push(result);
        }

        callback(results);
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

//#region Implement - Delete

api.Delete = class {
    static prepare(req, res) {
        let params = WebServer.parseReq(req).data;
        /*
        let storage = new RaterStorage(req, res)
        let customerId = (storage.account) ? storage.account.customerId : null
        if (customerId) params.customerId = customerId
        
        params.langId = null; // force null.
        params.branchId = null;
        params.enabled = true;
        */
        return params;
    }
    static async call(db, params) { 
        //return db.GetBranchs(params);
        return null;
    }
    static parse(db, data, callback) {
        let dbResult = dbutils.validate(db, data);
        let result = {}        
        result.data = null
        //result.src = dbResult.data
        result.errors = dbResult.errors
        //result.multiple = dbResult.multiple
        //result.datasets = dbResult.datasets
        result.out = dbResult.out

        let records = dbResult.data;
        let ret = {};
        /*
        records.forEach(rec => {
            if (!ret[rec.langId]) {
                ret[rec.langId] = []
            }
            let map = ret[rec.langId].map(c => c.branchId);
            let idx = map.indexOf(rec.branchId);
            let nobj;
            if (idx === -1) {
                // set id
                nobj = {}
                nobj.branchId = rec.branchId
                // init lang properties list.
                ret[rec.langId].push(nobj)
            }
            else {
                nobj = ret[rec.langId][idx];
            }
            nobj.branchName = rec.BranchName;
        })
        */
        // set to result.
        result.data = ret;
        callback(result);
    }
    static entry(req, res) {
        let db = new sqldb();
        let params = api.Delete.prepare(req, res);
        let fn = async () => { return api.Delete.call(db, params); }
        dbutils.exec(db, fn).then(data => {
            api.Delete.parse(db, data, (result) => {
                WebServer.sendJson(req, res, result);
            });
        })
    }
}

//#endregion

router.use(secure.checkAccess);
// routes for device
router.all('/devices', api.GetDevices.entry);
router.get('/devices/search/:id', api.GetDevice.entry);
router.post('/devices/search', api.GetDevice.entry);
router.post('/devices/save', api.Save.entry);
//router.post('/device/delete', api.Delete.entry);

const init_routes = (svr) => {
    svr.route('/customers/api/', router);
};

module.exports.init_routes = exports.init_routes = init_routes;