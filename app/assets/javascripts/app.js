var app = {

    conf: {
        beta: false // bool
    },

    setAddToHomescreen: function() {
        // Check to make sure iOS device, not web app mode and not a social browser (FB and TWTR)
        if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.isWebAppMode() && !app.isSocialBrowser() ) {
            // Check to make sure they just finished the confirmation page
            if ($('body').hasClass('mobile-games-page') && !app.isDevelopment() && !app.isPromo()) {
                $('body').addClass('overlay-screen add-to-home--ios');
            }
        };
    },

    showOnboarding: function() {
        if ( mobileCheck.iOS() && app.isWebAppMode() || mobileCheck.MobileChrome() || mobileCheck.Android() ) {
            if (Cookies.get('onboarding') !== 'shown') {
                window.location.href = window.location.origin + "/onboarding";
                Cookies.set('onboarding', 'shown', { expires: 365 });
            }
        }
    },

    runBetaMode: function() {
        $('.mobile-home .mobile-container').addClass('beta-version');
    },

    isLoggedIn: function() {
        return $('body').hasClass('logged-in');
    },

    isPromo: function() {
        return $('body').hasClass('dunkin-tester--mobile');
    },

    isDevelopment: function() {
        return $('body').hasClass('development');
    },

    // For Spacing Concerns - Testing with Mobile Chrome Browser
    isWAM: function() {
        if (app.isWebAppMode() || mobileCheck.MobileChrome()) {
            $('body').addClass('wam');
        }
    },

    scrollToBottom: function() {
        $('html, body').animate({
                scrollTop: $(document).height()
        }, 'slow');
    },

    scrollToElement: function(element, addSpace, animDuration) {
        var space = addSpace || 0,
            duration = animDuration || 500;
        $('html, body').animate({
            scrollTop: $(element).offset().top - space
        }, duration);
    },

    showShareDialog: function() {
        if (Cookies.get('login') === 'initial') {
        } else {
            Cookies.set('login', 'initial', '/games');
        }
    },

    isWebAppMode: function() {
        return window.navigator.standalone;
    },

    showRotateDialog: function() {
        $('body').addClass('overlay-screen overlay-screen--rotate');
    },

    changeOrientation: function() {
        if(window.orientation == 0) {
            // Portrait
            $('.mobile--overlay').removeClass('hide');
        }
        else {
            // Landscape
            $('.mobile--overlay').addClass('hide');
        }
    },

    hideCopyBtn: function() {
        if (mobileCheck.iOS()) {
            $('.refer-friend__copy-button').addClass('hide');
        }
    },

    toggleElementClass: function(el, className) {
        $(el).toggleClass(className);
        console.log('toggle dropdown');
    },

    // Tutorials
    show2048Tutorial: function() {
        if (Cookies.get('2048tutorial') !== 'shown' && $('body').hasClass('games-page')) {
            $('.js-game--2048').parent().attr('href', '/2048_tutorial');
            Cookies.set('2048tutorial', 'shown', { expires: 365});
        } else {
            $('.js-game--2048').parent().attr('href', '/2048_home');
        }
    },

    showDesktopModal: function() {
        $('.mobile-home .mobile-container').addClass('desktop--modal-blur');
    },

    checkDesktop: function() {
        if(!mobileCheck.any()) {
            app.showDesktopModal();
        }
    },

    fitToContainer: function(selector, ratio) {
        $(selector).fitText(ratio);
    },

    initheadroom: function(offset) {
            offset = offset || 60;
        $('.js-mobile-header').headroom({
            "offset": offset,
            "tolerance": 2.5,
            onUnpin: function() {
                console.log('unpin');
            }
        });
    },

    notify: function(el) {
        $(el).addClass('show');
    },

    isSocialBrowser: function() {
        if (navigator.userAgent.match(/(iPod|iPhone|iPad)/)) {
            if (navigator.userAgent.match(/FBAV/i)) {
                return "facebook";
            } else if (navigator.userAgent.match(/Twitter/i)){
                return "twitter";
            } else {
                return false;
            }
        } else {
            return false;
        }
    },

    getParams: function(param) {
      var get = (function(){
          var map = {};
          location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m, k, v){
              map[k] = v;
          });
          return map;
      }());

      var result = param ? get[param] : get
      return result
    },

    setBannerCopy: function(copy) {
        $('.js-notification-banner__copy').text(copy);
    },

    isConfirmed: function() {
        if (app.getParams("confirmed") == "true") {
            app.setBannerCopy('Email Confirmed!');
            $('body').addClass('show-banner');
        }
    },

    addSocialMediaClass: function() {
        if (app.isSocialBrowser()) {
            $('body').addClass('social-media-browser');
        }
    },

    showEmailUpdate: function() {
        $('.resend-email').slideUp(function(){
            $('.js-change_email_form').slideDown();
        });
    },

    initDatepicker: function() {
        $( ".js-datepicker" ).datepicker({
          changeMonth: true,
          changeYear: true,
          yearRange: "-100:-0"
        });
    },

    formatDate: function() {
        if ($('body').hasClass('confirmation-page--mobile')) {
            new Cleave('.js-cleave--date', {
                date: true,
                datePattern: ['m', 'd', 'Y']
            });
        }
    },

    bind: function() {
        $(".js-input--select").chosen({width: "100%", "disable_search": true});

        $('.js-show-email-form').on('click', function() {
            app.showEmailUpdate();
        });

        $('.js-share-dialog__close').click(function(){
            $('.js-share-dialog').removeClass('show');
        });

        $('.js-nav-dropdown__name').click(function(){
            $('.nav-dropdown').toggleClass('show');
            // app.toggleElementClass(this, 'show');
        });

        // Copy to clipboard
        $("body").on("copy", ".zclip", function(e) {
            e.clipboardData.clearData();
            e.clipboardData.setData("text/plain", $(this).data("zclip-text"));
            $(this).html('Copied!');
            $(this).addClass('copied')
            e.preventDefault();
        });

        $('.confirmation-page__radio-male').on('click', function() {
            $('#confirm_gender').val("1")
        });

        $('.confirmation-page__radio-female').on('click', function() {
            $('#confirm_gender').val("2")
        });
        $('.confirmation-page__radio-but').on('click', function() {
            console.log('clicked');
            $('.confirmation-page__radio-but').removeClass('gender-selected');
            $(this).addClass('gender-selected');
        });


        $('.js-overlay__opt-out').click(function(){
            Cookies.set('user', 'returning', { expires: 1 });
        });

        $('.js-game--2048').click(function(){
            Cookies.set('2048tutorial', 'shown', { expires: 365});
        });

        // Tooltip
        $('[data-toggle="tooltip"]').tooltip()

        // Modal dismiss
        $('.js-modal__link').click(function(){
            $('.mobile-container').removeClass('desktop--modal-blur');
        });

        $('.js-show-signup').click(function() {
            $('.js-show-signup').fadeOut(function() {
                $('.email-form').fadeIn();
                $('.js-auto-focus').focus();
            });
        });

        $(document).on('click', 'a[href^="#"]', function(e) {
            // target element id
            var id = $(this).attr('href');

            // prevent standard hash navigation (avoid blinking in IE)
            e.preventDefault();

            // animated top scrolling
            app.scrollToElement(id);
        });

        document.addEventListener("touchstart", function(){}, true);
    },

    init: function() {
        app.addSocialMediaClass();
        app.bind();
        app.fitToContainer(".js-inline-tout__title", 0.5);
        app.formatDate();
        app.hideCopyBtn();
        app.initDatepicker();
        app.isConfirmed();
        app.isWAM();
        app.notify();
        app.setAddToHomescreen();
        app.show2048Tutorial();
        app.showOnboarding();
        app.showShareDialog();
        // app.initheadroom();
    }
};
