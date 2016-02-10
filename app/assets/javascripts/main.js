$(document).ready(function(){
    // General app scripts
    app.init();
    siteCookies.init();
    // Cashout process
    if (mobileCheck.any()) {
        cashOut.init();
    } else {
        cashOutDesktop.init();
    }

    // Tab functionality
    tabs.init();

    //Remove this line once out of BETA
    $('.mobile-home .mobile-container').addClass('beta-version');

    // goo.gl/mGZagf - staging shortened URL
    var foo = navigator.userAgent;
    $('.secondary__desc').text(foo);
    // alert(navigator.userAgent);
});

$(window).load(function(){
    app.checkDesktop();
});
