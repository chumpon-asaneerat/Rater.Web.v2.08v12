let app;
(() => {
    console.log('debug break point here.')
    let tags = riot.mount('rater-web-app')
    let screenId = 'admin-home'
    screens.show(screenId)
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