$(document).ready(function(){
  app.init();
  cashOut.init();
  tabs.init();
  $('.mobile-home .mobile-container').addClass('beta-version');
});

$(window).load(function(){
  app.checkDesktop();
});
