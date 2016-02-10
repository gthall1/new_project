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
    if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
        if (navigator.userAgent.match(/FBAV/i)) {
            $('.welcome-box-m').text("FACEBOOK FOR iOS");
        } else if (navigator.userAgent.match(/Twitter/i)){
            $('.welcome-box-m').text("TWITTER FOR iOS");
        }
    }
});

$(window).load(function(){
    app.checkDesktop();
});
