const util = {}
util.x =  (() => {
    let slice = Array.prototype.slice, push = Array.prototype.push
    class klass {
        constructor() { 
            this.name = 'sample by ES6'
            this._data = 0
            let properties = slice.call(arguments, 0);
            console.log('properties:', properties)
        }
        init() { 
            return this.name + 'init called.'
        }
        /** get data */
        get data() { return this._data }
        /** set data */
        set data(value) { this._data = value }
    }
    return klass
})()

util.y =  (() => {

    let slice = Array.prototype.slice, push = Array.prototype.push
    function klass() {
        this.name = 'sample by old js'
        this._data = 0
        let properties = slice.call(arguments, 0);
        console.log('properties:', properties)
    }
    klass.prototype.init = function() { 
        return this.name + 'init called.'
    }
    Object.defineProperty(klass.prototype, "data", {
        /** get data */
        get: function() {
            return this._data
        },
        /** set data */
        set: function(value) {
            this._data = value
        }
    });
    return klass
})()

let prop = (propname, getfn, setfn) => {
    let obj = {};
    obj[propname] = { get: getfn, set: setfn };
    Object.defineProperties(this, obj);
}

//how to use prop function
prop.apply(util.y.prototype, [ 
    "total", 
    function () { return this._total },
    function (value) { return this._total = value }
]);

let x = new util.x(1, 2, 3)
let y = new util.y(1, 'test')
x.data++;
y.data++;
y.total = 12
console.log(x, x.init())
console.log(y, y.init())
