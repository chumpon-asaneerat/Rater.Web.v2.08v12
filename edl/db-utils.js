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
            result = checkForError(data);
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
}

module.exports.DbUtils = exports.DbUtils = DbUtils;
