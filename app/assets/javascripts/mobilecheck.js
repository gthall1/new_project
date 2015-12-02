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
