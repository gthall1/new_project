var cookies={setAddToHomescreen:function(){mobileCheck.iOS()&&("returning"===Cookies.get("user")?console.log("Welcome home!"):(Cookies.set("user","returning"),$("body").addClass("overlay-screen")))},registerViewport:function(){"standalone"in navigator&&!navigator.standalone&&/iphone|ipod|ipad/gi.test(navigator.platform)&&/Safari/i.test(navigator.appVersion)&&alert("added to homescreen")},showShareDialog:function(){"initial"===Cookies.get("login")?console.log("Welcome back!"):(Cookies.set("login","initial","/games"),$(".js-share-dialog").addClass("show"))},changeOrientation:function(){0==window.orientation?alert("Portrait"):alert("Landscape")},bind:function(){$(".js-share-dialog__close").click(function(){$(".js-share-dialog").removeClass("show")}),$(window).on("orientationchange",function(){cookies.changeOrientation()})},init:function(){cookies.showShareDialog(),cookies.setAddToHomescreen(),cookies.bind(),cookies.registerViewport()}},mobileCheck={Android:function(){return!!navigator.userAgent.match(/Android/i)},BlackBerry:function(){return!!navigator.userAgent.match(/BlackBerry/i)},iOS:function(){return!!navigator.userAgent.match(/iPhone|iPad|iPod/i)},Opera:function(){return!!navigator.userAgent.match(/Opera Mini/i)},Windows:function(){return!!navigator.userAgent.match(/IEMobile/i)},MobileChrome:function(){return!!navigator.userAgent.match("CriOS")},any:function(){return mobileCheck.Android()||mobileCheck.BlackBerry()||mobileCheck.iOS()||mobileCheck.Opera()||mobileCheck.Windows()||mobileCheck.MobileChrome()}};