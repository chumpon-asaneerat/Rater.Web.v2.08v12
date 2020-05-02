const path = require('path');
const rootPath = process.env['ROOT_PATHS'];
const nlib = require(path.join(rootPath, 'nlib', 'nlib'));
//const sqldb = require(path.join(nlib.paths.root, 'RaterWebv2x08r12.db'));

class DbUtils {
    static async exec(db, callback) {
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
    static validate(db, data) {
        let result = data;
        if (!result) {
            result = db.error(db.errorNumbers.NO_DATA_ERROR, 'No data returns');
        }
        else {
            result = DbUtils.checkForError(data);
        }
        return result;
    }
    static checkForError(data) {
        let result = data;
        if (result.out && result.out.errNum && result.out.errNum !== 0) {
            result.errors.hasError = true;
            result.errors.errNum = result.out.errNum;
            result.errors.errMsg = result.out.errMsg;
        }
        return result;
    }
    static hasData (result) {
        return !result.errors.hasError && result.data && result.data.length > 0 && result.data[0];
    }
    static buildTree(result, idFld, mapFieldsCallback) {
        let ret = TreeResultBuilder.buildTree(result, idFld, mapFieldsCallback)
        return ret;
    }
}

class TreeResultBuilder {
    static buildTree(result, idFld, mapFieldsCallback) {
        let ret = {}
        if (result && result.data) {
            let records = result.data
            TreeResultBuilder.processRecords(ret, records, idFld, mapFieldsCallback)
        }
        return ret;
    }
    static processRecords(ret, records, idFld, mapFieldsCallback) {
        records.forEach((record) => {
            if (!ret[record.langId]) {
                // no array for target language so create it.
                ret[record.langId] = []
            }
            let langObj = ret[record.langId]
            TreeResultBuilder.processRecord(langObj, record, idFld, mapFieldsCallback)
        })
}
    static processRecord(langObj, record, idFld, mapFieldsCallback) {
        let map = langObj.map(c => c[idFld])
        let idx = map.indexOf(record[idFld])
        let nobj
        if (idx === -1) {
            nobj = {} // create new object.                    
            nobj[idFld] = record[idFld] // set id
            langObj.push(nobj) // keep to array
        }
        else {
            nobj = langObj[idx]
        }
        if (mapFieldsCallback) mapFieldsCallback(nobj, record)
    }
}


module.exports.DbUtils = exports.DbUtils = DbUtils;
