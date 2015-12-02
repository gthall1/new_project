
var cashOutDesktop = {
  conf: {
    cashoutForm: '.cash-out__wrapper',
    cashoutRedo: '.cash-out__redo'
  },

  hideCheckout: function () {
    $(cashOutDesktop.conf.cashoutForm).slideUp();
    $(cashOutDesktop.conf.cashoutRedo).addClass('hide');
    $('.cash-out__submit').removeClass('show');
  },

  showAllOptions: function () {
    $('.venmo-choice, .paypal-choice').fadeIn();
  },

  showCheckoutType: function(el) {
    var cashoutType = $(el).attr('data-checkout');
    app.scrollTo();

    $('.cash-out__submit').addClass('show');
    $('.' + cashoutType + '-select').addClass('show');
    $(cashOutDesktop.conf.cashoutForm).slideDown();

    if (cashoutType === "venmo") {
      $('.paypal-choice').fadeOut();
      $(cashOutDesktop.conf.cashoutRedo).removeClass('hide');
    } else {
      $('.venmo-choice').fadeOut();
      $(cashOutDesktop.conf.cashoutRedo).removeClass('hide');
    }
  },

  bind: function() {
    $('.venmo-choice, .paypal-choice').click(function(e){
      cashOutDesktop.showCheckoutType(this);
    });

    $(cashOutDesktop.conf.cashoutRedo).click(function() {
      cashOutDesktop.hideCheckout();
      cashOutDesktop.showAllOptions();
      $('.cash-out__fields').removeClass('show');
    });
  },

  init: function() {
    cashOutDesktop.bind();
    cashOutDesktop.hideCheckout();
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
