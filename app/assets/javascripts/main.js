$(document).ready(function(){
  app.init();
  cashOut.init();
  tabs.init();

  //Remove this line once out of BETA
  $('.mobile-home .mobile-container').addClass('beta-version');
});

$(window).load(function(){
  app.checkDesktop();
});
