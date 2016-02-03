var siteCookies = {
    settings : {
        surveyNotification : '.js-survey-notification'
    },

    surveyCookie: function() {
        if(Cookies.get('survey') !== "1") {
            app.notify(siteCookies.settings.surveyNotification);
        }
    },

    init: function() {
        siteCookies.surveyCookie();
    }
}
