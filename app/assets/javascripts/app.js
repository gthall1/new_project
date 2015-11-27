var app = {
  // Script to prompt user to add Luckee App shortcut to homescreen
  setAddToHomescreen: function() {
    if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.checkAppMode()) {
      if (Cookies.get('user') === 'returning') {
        console.log('Welcome home!');
      } else {
          Cookies.set('user', 'returning', { expires: 1 });
          $('body').addClass('overlay-screen add-to-home');
      }
    };
  },

  showShareDialog: function() {
    if (Cookies.get('login') === 'initial') {
      console.log('Welcome back!');
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

  bind: function() {
    $('.js-share-dialog__close').click(function(){
      $('.js-share-dialog').removeClass('show');
    });

    // Copy to clipboard
    $("body").on("copy", ".zclip", function(e) {
      e.clipboardData.clearData();
      e.clipboardData.setData("text/plain", $(this).data("zclip-text"));
      $(this).html('Copied!');
      $(this).addClass('copied')
      e.preventDefault();
    });

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
    app.bind();
  }
};


var mobileCheck = {
    Android: function() {
        return !!(navigator.userAgent.match(/Android/i));
    },
    BlackBerry: function() {
        return !!(navigator.userAgent.match(/BlackBerry/i));
    },
    iOS: function() {
        return !!(navigator.userAgent.match(/iPhone|iPad|iPod/i));
    },
    Opera: function() {
        return !!(navigator.userAgent.match(/Opera Mini/i));
    },
    Windows: function() {
        return !!(navigator.userAgent.match(/IEMobile/i));
    },
    MobileChrome: function() {
      return !!(navigator.userAgent.match('CriOS'));
    },
    any: function() {
        return (mobileCheck.Android() || mobileCheck.BlackBerry() || mobileCheck.iOS() || mobileCheck.Opera() || mobileCheck.Windows() || mobileCheck.MobileChrome());
    }
};

var tabs = {
  conf: {
    tab: '.tab-section'
  },

  switch: function($tab) {
    var tabCategory = $tab.data('tab-cat');

    $('.tab-toggle').removeClass('active');
    $tab.addClass('active');
    $(tabs.conf.tab).addClass('hidden');

    $(tabCategory).removeClass('hidden');
  },

  bind: function() {
    $('.tab-toggle').click(function(e){
      tabs.switch($(this));
    });
  },

  init: function() {
    tabs.bind();
  }
};

var cashOut = {
  paypal: function() {
    $('.page-title').html('Paypal Details');
    $('.cash-out__wrapper').addClass('slide-in cash-out__paypal');
    $('.inner-page__list').addClass('cash-out--hide-list');
    $(".back-link").hide();
    $(".back-choice").show();
    $("#cash_out_cashout_type").val(1);
  },

  venmo: function() {
    $('.page-title').html('Venmo Details');
    $('.cash-out__wrapper').addClass('slide-in cash-out__venmo');
    $('.inner-page__list').addClass('cash-out--hide-list');
    $(".back-link").hide();
    $(".back-choice").show();
    $("#cash_out_cashout_type").val(0);
  },

  restart: function() {
    $('.page-title').html('Cash');
    $('.cash-out__wrapper').removeClass('slide-in cash-out__venmo cash-out__paypal');
    $('.inner-page__list').removeClass('cash-out--hide-list');
    $(".back-link").show();
    $(".back-choice").hide();
  },

  bind: function() {
    $( ".back-choice" ).click(function() {
      cashOut.restart();
    });

    $( ".venmo-choice" ).click(function() {
      cashOut.venmo();
    });

    $( ".paypal-choice" ).click(function() {
      cashOut.paypal();
    });
  },

  init: function() {
    cashOut.bind();
  }
};
