$(document).ready(function(){
  app.init();
  cashOut.init();
  tabs.init();
  $('.mobile-home .mobile-container').addClass('beta-version');

  $("body").on("copy", ".zclip", function(e) {
    e.clipboardData.clearData();
    e.clipboardData.setData("text/plain", $(this).data("zclip-text"));
    $(this).html('Copied!');
    e.preventDefault();
  });
});

$(window).load(function(){
  app.checkDesktop();
});
