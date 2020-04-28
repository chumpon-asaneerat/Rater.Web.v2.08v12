let app;
(() => {
    // load css/js files.
    let urls = [
        '/dist/css/tabulator.min.css',
        '/dist/js/tabulator.min.js'
    ]
    nlib.document.load(...urls).then(() => {
        let tags = riot.mount('rater-web-app')
        let screenId = 'member-manage'
        screens.show(screenId)
    });
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