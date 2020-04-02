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
