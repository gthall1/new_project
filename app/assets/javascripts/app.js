var app = {
    // Script to prompt user to add Luckee App shortcut to homescreen
    setAddToHomescreen: function() {
        if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.isWebAppMode() && Cookies.get('onboarding-complete') === 'true') {
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

    scrollTo: function() {
        $('html, body').animate({
                scrollTop: $(document).height()
        }, 'slow');
    },
    showShareDialog: function() {
        if (Cookies.get('login') === 'initial') {
            // console.log('Welcome back!');
        } else {
            Cookies.set('login', 'initial', '/games');
            // $('.js-share-dialog').addClass('show');
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
        // app.initheadroom();
        app.fitToContainer(".inline-tout__title", 0.5);
        app.bind();
        app.isWAM();
    }
};
