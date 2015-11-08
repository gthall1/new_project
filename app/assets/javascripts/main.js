$(document).ready(function(){
  app.init();
  cashOut.init();

  $("body").on("copy", ".zclip", function(e) {
    alert('copied');
    e.clipboardData.clearData();
    e.clipboardData.setData("text/plain", $(this).data("zclip-text"));
    $(this).html('Copied!');
    e.preventDefault();
  });
});

$(window).load(function(){
  app.checkDesktop();
});
