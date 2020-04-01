let app;

(() => {
    /*
    let tags = riot.mount('rater-web-app')
    let screenId = 'rater-home'
    screens.show(screenId)
    */
    app = {}
    nlib.signin = () => {
        secure.account = {
            username: 'a&a.co.th', 
            password: '1234',
            IsEDLUser: false
        }
        secure.signin('EDL-C2020030001')
    }
    nlib.signout = () => {
        secure.signout()
    }
    nlib.info = () => {
        if (!app.info) {
            app.info = nlib.cookie.getJson('client')
        }
        console.log(app.info)
    }
})();
