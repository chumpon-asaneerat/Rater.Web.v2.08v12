//#region EventService class

class EventService {
    constructor() {
        this.name = {}
    }
    raise(eventName, data) {
        // Raise event.
        let evt;
        if (data) {
            evt = new CustomEvent(eventName, { detail: { data: data } });
        }
        else {
            evt = new CustomEvent(eventName);
        }
        document.dispatchEvent(evt);
    }
}

//console.log('Init event service...');
window.events = window.events || new EventService();
/** 
 * The Document event helper class.
 */
window.events.doc = class {
    /**
     * Add document event listener.
     * @param {String} evtName The Event Name.
     * @param {Function} handle The Event Callback Function.
     */
    static add(evtName, handle) { document.addEventListener(evtName, handle) }
    /**
     * Remove document event listener.
     * @param {String} evtName The Event Name.
     * @param {Function} handle The Event Callback Function.
     */
    static remove(evtName, handle) { document.removeEventListener(evtName, handle) }
}

//#endregion

//#region ScreenService class

/** app screen changed. */
window.events.name.ScreenChanged = 'app:screen:change';

class ScreenService {
    constructor() {
        this.current = {
            screenId: ''
        };
    }
    show(screenId) {
        if (this.current.screenId !== screenId) {
            // change screen id.
            this.current.screenId = screenId
            // Raise event.
            events.raise(events.name.ScreenChanged)
        }
    }
    is(screenId) { return this.current.screenId === screenId }
}
; (function () {
    //console.log('Init screen service...');
    window.screens = window.screens || new ScreenService();
})();

//#endregion
