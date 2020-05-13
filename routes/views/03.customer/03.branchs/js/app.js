let app;
(() => {
    let tags = riot.mount('rater-web-app')
    let screenId = 'member-manage'
    screens.show(screenId)
})();

/*
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
