var app = {
  // Script to prompt user to add Luckee App shortcut to homescreen
  setAddToHomescreen: function() {
    if (mobileCheck.iOS() && !mobileCheck.MobileChrome() && !app.checkAppMode()) {
      if (Cookies.get('user') === 'returning') {
        console.log('Welcome home!');
      } else {
          Cookies.set('user', 'returning');
          $('body').addClass('overlay-screen add-to-home');
      }
    };
  },

  showShareDialog: function() {
    if (Cookies.get('login') === 'initial') {
      console.log('Welcome back!');
    } else {
      Cookies.set('login', 'initial', '/games');
      $('.js-share-dialog').addClass('show');
    }
  },

  checkAppMode: function() {
    return window.navigator.standalone;
  },

  showRotateDialog: function() {
    $('body').addClass('overlay-screen overlay-screen--rotate');
  },

  changeOrientation: function() {
    if(window.orientation == 0) // Portrait
    {
      $('.mobile--overlay').removeClass('hide');
    }
    else // Landscape
    {
      $('.mobile--overlay').addClass('hide');
    }
  },

  bind: function() {
    $('.js-share-dialog__close').click(function(){
      $('.js-share-dialog').removeClass('show');
    });
  },

  init: function() {
    app.showShareDialog()
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
