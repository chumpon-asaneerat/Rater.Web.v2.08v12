/*
function createClass() {
    var parent = null, properties = slice.call(arguments, 0);

    if (typeof properties[0] === 'function') { parent = properties.shift(); }
    function klass() { this.initialize.apply(this, arguments); }

    klass.superclass = parent;
    klass.subclasses = [];

    if (parent) {
      Subclass.prototype = parent.prototype;
      klass.prototype = new Subclass();
      parent.subclasses.push(klass);
    }
    for (var i = 0, length = properties.length; i < length; i++) {
      addMethods(klass, properties[i], parent);
    }
    if (!klass.prototype.initialize) {
      klass.prototype.initialize = emptyFunction;
    }
    klass.prototype.constructor = klass;
    klass.prototype.callSuper = callSuper;
    return klass;
  }
*/
var slice = Array.prototype.slice, push = Array.prototype.push;
function emptyFunction() {}
function Subclass() { }
addMethods = function(klass, source, parent) {
    for (var property in source) {
      if (property in klass.prototype &&
          typeof klass.prototype[property] === 'function' &&
          (source[property] + '').indexOf('callSuper') > -1) {
        klass.prototype[property] = (function(property) {
          return function() {
            var superclass = this.constructor.superclass;
            this.constructor.superclass = parent;
            var returnValue = source[property].apply(this, arguments);
            this.constructor.superclass = superclass;
            if (property !== 'initialize') {
              return returnValue;
            }
          };
        })(property);
      }
      else {
        klass.prototype[property] = source[property];
      }

      //if (IS_DONTENUM_BUGGY) {
        if (source.toString !== Object.prototype.toString) {
          klass.prototype.toString = source.toString;
        }
        if (source.valueOf !== Object.prototype.valueOf) {
          klass.prototype.valueOf = source.valueOf;
        }
      //}
    }
}
function callSuper(methodName) {
    var parentMethod = null,
        _this = this;

    // climb prototype chain to find method not equal to callee's method
    while (_this.constructor.superclass) {
      var superClassMethod = _this.constructor.superclass.prototype[methodName];
      if (_this[methodName] !== superClassMethod) {
        parentMethod = superClassMethod;
        break;
      }
      // eslint-disable-next-line
      _this = _this.constructor.superclass.prototype;
    }

    if (!parentMethod) {
      return console.log('tried to callSuper ' + methodName + ', method not found in prototype chain', this);
    }

    return (arguments.length > 1)
      ? parentMethod.apply(this, slice.call(arguments, 1))
      : parentMethod.call(this);
  }

function createClass() {
    var parent = null, properties = slice.call(arguments, 0);
    if (typeof properties[0] === 'function') { parent = properties.shift(); }
    function klass() { 
        // constructor.
        this.initialize.apply(this, arguments);
    }
    klass.superclass = parent;
    klass.subclasses = [];
    if (parent) {
        Subclass.prototype = parent.prototype;
        klass.prototype = new Subclass();
        parent.subclasses.push(klass);
    }
    for (var i = 0, length = properties.length; i < length; i++) {
        addMethods(klass, properties[i], parent);
    }
    if (!klass.prototype.initialize) {
        klass.prototype.initialize = emptyFunction;
    }
    klass.prototype.constructor = klass;
    klass.prototype.callSuper = callSuper;
    return klass;
}

(() => {
    console.log('script.js loaded.')
    let obj = {
        type: 'LabeledRect',
        initialize: function(options) {
        },
        toObject: function() { 
        },
        _render: function(ctx) {
        }
    }
    console.log(obj)

    let Base = createClass(null, {})
    console.log('Base:', Base)
    console.log('Base instance:', new Base())
    let Rect = createClass(Base, { type:'Rect' })
    console.log('Rect:', Rect)
    console.log('Rect instance:', new Rect())

    class es6 {
        constructor() {
            this.type = 'LabeledRect'
        }
        initialize(options) { }
        toObject() { }
        _render(ctx) { }
    }

    console.log(es6.prototype)
})();