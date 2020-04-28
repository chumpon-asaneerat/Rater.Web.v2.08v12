let app;

const loadLibrary = (callback) => {
    let iCnt = 0;
    let completed = () => {
        ++iCnt
        if (iCnt === 2) {
            if (callback) callback()
        }
    }

    nlib.document.load('/dist/css/tabulator.min.css', 'css', completed)
    nlib.document.load('/dist/js/tabulator.min.js', 'js', completed)
}

const run = () => {
    let tags = riot.mount('rater-web-app')
    let screenId = 'member-view'
    screens.show(screenId)
}

(() => {
    // load css/js files.
    let loaded = (window.Tabulator !== undefined && window.Tabulator !== null)
    console.log('Tabulator:', (loaded) ? 'loaded' : 'not loaded')
    if (!loaded) { 
        loadLibrary(run)
    } 
    else { 
        run()
    }
})();
/*
let app;
(() => {
    nlib.signout = () => { secure.signout() }

    nlib.info = () => {
        if (!app.info) {
            app.info = nlib.cookie.getJson('client')
        }
        console.log(app.info)
    }
 })();
*/