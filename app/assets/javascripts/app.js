var app = {
  // Script to prompt user to add Luckee App shortcut to homescreen
  setAddToHomescreen: function() {
    if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.checkAppMode()) {
      if (Cookies.get('user') === 'returning') {
        // console.log('Welcome home!');
      } else {
          $('body').addClass('overlay-screen add-to-home');
      }
    };
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

  checkAppMode: function() {
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
  },

  // Tutorials
  show2048Tutorial: function() {
    if (Cookies.get('2048tutorial') !== 'shown' && $('body').hasClass('mobile-games-page')) {
      $('.js-game--2048').parent().attr('href', '/2048_tutorial');
      Cookies.set('2048tutorial', 'shown', { expires: 365});
    } else if (mobileCheck.any()) {
      $('.js-game--2048').parent().attr('href', '/2048_home');
    }
  },

  bind: function() {
    $('.js-share-dialog__close').click(function(){
      $('.js-share-dialog').removeClass('show');
    });

    $('.nav-dropdown').click(function(){
      app.toggleElementClass(this, 'show');
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
  },

  showDesktopModal: function() {
    $('.mobile-home .mobile-container').addClass('desktop--modal-blur');
  },

  checkDesktop: function() {
    if(!mobileCheck.any()) {
      app.showDesktopModal();
    }
  },

  init: function() {
    app.hideCopyBtn();
    app.showShareDialog();
    app.setAddToHomescreen();
    app.show2048Tutorial();
    app.bind();
  }
};
