$(document).ready(function(){app.init(),cashOut.init(),$(".mobile-home .mobile-container").addClass("beta-version"),$("body").on("copy",".zclip",function(t){t.clipboardData.clearData(),t.clipboardData.setData("text/plain",$(this).data("zclip-text")),$(this).html("Copied!"),t.preventDefault()})}),$(window).load(function(){app.checkDesktop()});