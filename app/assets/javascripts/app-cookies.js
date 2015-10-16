$(document).ready(function(){
    if (Cookies.get('user') === 'returning') {
      console.log('Not first time user');
    } else {
        Cookies.set('user', 'returning');
        $('body').addClass('overlay-screen');
    }
});
