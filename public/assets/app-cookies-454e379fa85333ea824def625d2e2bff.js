var app={setAddToHomescreen:function(){!mobileCheck.iOS()||mobileCheck.MobileChrome()||app.checkAppMode()||("returning"===Cookies.get("user")?console.log("Welcome home!"):(Cookies.set("user","returning",{expires:1}),$("body").addClass("overlay-screen add-to-home")))},showShareDialog:function(){"initial"===Cookies.get("login")?console.log("Welcome back!"):Cookies.set("login","initial","/games")},checkAppMode:function(){return window.navigator.standalone},showRotateDialog:function(){$("body").addClass("overlay-screen overlay-screen--rotate")},changeOrientation:function(){0==window.orientation?$(".mobile--overlay").removeClass("hide"):$(".mobile--overlay").addClass("hide")},paypalCashOut:function(){$(".page-title").html("Paypal Details"),$(".cash-out__wrapper").addClass("slide-in cash-out__paypal"),$(".cash-out").addClass("cash-out--hide-list"),$(".back-link").hide(),$(".back-choice").show(),$("#cash_out_cashout_type").val(1)},venmoCashOut:function(){$(".page-title").html("Venmo Details"),$(".cash-out__wrapper").addClass("slide-in cash-out__venmo"),$(".cash-out").addClass("cash-out--hide-list"),$(".back-link").hide(),$(".back-choice").show(),$("#cash_out_cashout_type").val(0)},restartCashOut:function(){$(".page-title").html("Cash Type"),$(".cash-out__wrapper").removeClass("slide-in cash-out__venmo cash-out__paypal"),$(".cash-out").removeClass("cash-out--hide-list"),$(".back-link").show(),$(".back-choice").hide()},bind:function(){$(".js-share-dialog__close").click(function(){$(".js-share-dialog").removeClass("show")}),$(".back-choice").click(function(){app.restartCashOut()}),$(".venmo-choice").click(function(){app.venmoCashOut()}),$(".paypal-choice").click(function(){app.paypalCashOut()})},init:function(){app.showShareDialog(),app.setAddToHomescreen(),app.bind()}},mobileCheck={Android:function(){return!!navigator.userAgent.match(/Android/i)},BlackBerry:function(){return!!navigator.userAgent.match(/BlackBerry/i)},iOS:function(){return!!navigator.userAgent.match(/iPhone|iPad|iPod/i)},Opera:function(){return!!navigator.userAgent.match(/Opera Mini/i)},Windows:function(){return!!navigator.userAgent.match(/IEMobile/i)},MobileChrome:function(){return!!navigator.userAgent.match("CriOS")},any:function(){return mobileCheck.Android()||mobileCheck.BlackBerry()||mobileCheck.iOS()||mobileCheck.Opera()||mobileCheck.Windows()||mobileCheck.MobileChrome()}};