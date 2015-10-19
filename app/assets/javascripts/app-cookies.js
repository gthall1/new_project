var cookies = {
  // Script to prompt user to add Luckee App shortcut to homescreen
  setAddToHomescreen: function() {
    if (Cookies.get('user') === 'returning') {
      console.log('Welcome home!');
    } else {
        Cookies.set('user', 'returning');
        $('body').addClass('overlay-screen');
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

  bind: function() {
    $('.js-share-dialog__close').click(function(){
      $('.js-share-dialog').removeClass('show');
    });
  },

  init: function() {
    cookies.showShareDialog()
    cookies.setAddToHomescreen();
    cookies.bind();
  }
};
