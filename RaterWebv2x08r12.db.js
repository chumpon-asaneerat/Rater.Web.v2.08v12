// required to manual set require path for nlib-mssql.
const SqlServer = require('./nlib/nlib-mssql');
const schema = require('./schema/RaterWebv2x08r12.schema.json');

const RaterWebv2x08r12 = class extends SqlServer {
    constructor() {
        super();
        // should match with nlib.config.json
        this.database = 'default'
    }
    async connect() {
        return await super.connect(this.database);
    }
    async disconnect() {
        await super.disconnect();
    }

}

module.exports = exports = RaterWebv2x08r12;
