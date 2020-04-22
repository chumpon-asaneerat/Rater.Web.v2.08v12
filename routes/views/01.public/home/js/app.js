let app;

(() => {
    let tags = riot.mount('rater-web-app')
    //let screenId = 'rater-home'
    //screens.show(screenId)
})();
/*
(() => {
    app = {}
    nlib.edl = {}
    nlib.edl.admin = {}
    nlib.edl.admin.signin = () => {
        secure.account = {
            username: 'raterweb2-admin@edl.co.th', 
            password: '1234',
            IsEDLUser: true
        }
        secure.signin(null)
    }
    nlib.edl.supervisor = {}
    nlib.edl.supervisor.signin = () => {
        secure.account = {
            username: 'chanon@edl.co.th', 
            password: '1234',
            IsEDLUser: true
        }
        secure.signin(null)
    }
    nlib.edl.staff = {}
    nlib.edl.staff.signin = () => {
        secure.account = {
            username: 'pranee@edl.co.th', 
            password: '1234',
            IsEDLUser: true
        }
        secure.signin(null)
    }
    nlib.customer = {}
    nlib.customer.admin = {}
    nlib.customer.admin.signin = () => {
        secure.account = {
            username: 'a&a.co.th', 
            password: '1234',
            IsEDLUser: false
        }
        secure.signin('EDL-C2020030001')
    }
    nlib.customer.exclusive = {}
    nlib.customer.exclusive.signin = () => {
        secure.account = {
            username: 'sodsri@edl.co.th', 
            password: '1234',
            IsEDLUser: false
        }
        secure.signin('EDL-C2020030001')
    }
    nlib.customer.staff = {}
    nlib.customer.staff.signin = () => {
        secure.account = {
            username: 'kanya@edl.co.th', 
            password: '1234',
            IsEDLUser: false
        }
        secure.signin('EDL-C2020030001')
    }
    nlib.device = {}
    
    nlib.signout = () => { secure.signout() }

    nlib.info = () => {
        if (!app.info) {
            app.info = nlib.cookie.getJson('client')
        }
        console.log(app.info)
    }
})();
*/