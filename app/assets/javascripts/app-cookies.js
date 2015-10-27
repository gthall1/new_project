var cookies = {
  // Script to prompt user to add Luckee App shortcut to homescreen
  setAddToHomescreen: function() {
    if (mobileCheck.iOS() && mobileCheck.Safari()) {
      if (Cookies.get('user') === 'returning') {
        console.log('Welcome home!');
      } else {
          Cookies.set('user', 'returning');
          $('body').addClass('overlay-screen');
      }
    };
  },

  registerViewport: function() {
    if ('standalone' in navigator && !navigator.standalone && (/iphone|ipod|ipad/gi).test(navigator.platform) && (/Safari/i).test(navigator.appVersion)) {
        alert('added to homescreen');
    }
  },

  showShareDialog: function() {
    if (Cookies.get('login') === 'initial') {
      console.log('Welcome back!');
    } else {
      Cookies.set('login', 'initial', '/games');
      $('.js-share-dialog').addClass('show');
    }
  },

  changeOrientation: function() {
    if(window.orientation == 0) // Portrait
    {
      alert('Portrait');
    }
    else // Landscape
    {
      alert('Landscape');
    }
  },

  // listenForOrientation: function() {
  //   $(window).on("orientationchange",function(){
  //     cookies.changeOrientation();
  //   });
  // }

  bind: function() {
    $('.js-share-dialog__close').click(function(){
      $('.js-share-dialog').removeClass('show');
    });

    $(window).on("orientationchange",function(){
      cookies.changeOrientation();
    });
  },

  init: function() {
    cookies.showShareDialog()
    cookies.setAddToHomescreen();
    cookies.bind();
    cookies.registerViewport();
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
    Safari: function() {
        return !!(navigator.userAgent.match(/Safari/i));
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
