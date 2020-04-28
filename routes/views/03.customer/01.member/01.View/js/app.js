let app;

const loadLibrary = (completed) => {
    let urls = [
        '/dist/css/tabulator.min.css',
        '/dist/js/tabulator.min.js'
    ]
    nlib.document.load(completed, ...urls);
}
const run = () => {
    let tags = riot.mount('rater-web-app')
    let screenId = 'member-view'
    screens.show(screenId)
}

(() => {
    // load css/js files.
    loadLibrary(run)
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