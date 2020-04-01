let app;

(() => {
    /*
    let tags = riot.mount('rater-web-app')
    let screenId = 'rater-home'
    screens.show(screenId)
    */
   nlib.signin = () => {
       secure2.signin('EDL-C2020030001', 'a&a.co.th', '1234')
   }
   nlib.signout = () => {
    secure2.signout('accessId')
}
})();
