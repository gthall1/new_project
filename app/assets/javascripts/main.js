$(document).ready(function(){
    // General app scripts
    app.init();
    formValidation.init();
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
});

$(window).load(function(){
    app.checkDesktop();
    $('.alert').addClass('show');
    window.setTimeout(function(){$('.alert').removeClass('show');}, 9000);
});
