var app = {
    // Script to prompt user to add Luckee App shortcut to homescreen
    setAddToHomescreen: function() {
        if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.isWebAppMode() && Cookies.get('onboarding-complete') === 'true' && !app.isSocialBrowser() ) {
            if (Cookies.get('user') === 'returning') {
                console.log('Welcome home!');
            } else {
                    $('body').addClass('overlay-screen add-to-home');
            }
        };
    },

    showOnboarding: function() {
        if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.isWebAppMode()) {
            if (Cookies.get('onboarding') !== 'shown') {
                window.location.href = window.location.origin + "/onboarding";
                Cookies.set('onboarding', 'shown', { expires: 365 });
            }
        };
    },



    isWAM: function() {
        if (app.isWebAppMode()) {
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

    is_confirmed: function() {
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

    bind: function() {
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
            $('.js-show-signup').fadeOut();
            $('.email-form').slideDown();
        });

        $(document).on('click', 'a[href^="#"]', function(e) {
            // target element id
            var id = $(this).attr('href');

            // prevent standard hash navigation (avoid blinking in IE)
            e.preventDefault();

            // animated top scrolling
            app.scrollToElement(id);
        });

        // $('.js-survery-link').click(function() {
        //     Cookies.set('survey_0', 'clicked', { expires: 365 });
        // })

        document.addEventListener("touchstart", function(){}, true);
    },

    init: function() {
        app.hideCopyBtn();
        app.showShareDialog();
        app.setAddToHomescreen();
        app.show2048Tutorial();
        app.showOnboarding();
        app.notify();
        app.is_confirmed();
        app.fitToContainer(".js-inline-tout__title", 0.5);
        app.bind();
        app.isWAM();
        app.addSocialMediaClass();
        // app.initheadroom();
    }
};
