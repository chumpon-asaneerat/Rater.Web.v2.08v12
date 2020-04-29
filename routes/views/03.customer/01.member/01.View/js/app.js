let app;
(() => {
    let files = [
        '/dist/css/tabulator.min.css',
        '/dist/js/tabulator.min.js',
        '/dist/css/themes/default/style.min.css',
        '/dist/js/jstree.min.js',
        '/dist/css/highcharts.css',
        '/dist/js/highcharts.js'
    ]
    nlib.runtime.file.load(...files).then(() => {
        //console.log('mount app')
        let tags = riot.mount('rater-web-app')
        let screenId = 'member-view'
        screens.show(screenId)
    })
})()
/*
let app;
(() => {
    // load css/js files.
    let cssFiles = [
        '/dist/css/tabulator.min.css',
        '/dist/css/themes/default/style.min.css',
        '/dist/css/highcharts.css'
    ]
    let cssLoaded = false
    nlib.runtime.css.load(...cssFiles).then(() => {
        cssLoaded = true
        console.log('all css loaded')
        run()
    })

    let jsFiles = [
        '/dist/js/tabulator.min.js',
        '/dist/js/jstree.min.js',
        '/dist/js/highcharts.js'
    ]
    let jsLoaded = false
    nlib.runtime.js.load(...jsFiles).then(() => {
        jsLoaded = true
        console.log('all js loaded')
        run()
    })

    let run = () => {
        if (cssLoaded && jsLoaded) {
            console.log('mount app')
            let tags = riot.mount('rater-web-app')
            let screenId = 'member-view'
            screens.show(screenId)
        }
    }
})();
*/
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