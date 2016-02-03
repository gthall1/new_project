var siteCookies = {
    settings : {
        surveyNotification : '.js-survey-notification'
    },

    surveyCookie: function() {
        if(Cookies.get('survey_0') !== 'clicked') {
            app.notify(siteCookies.settings.surveyNotification);
        }
    },

    init: function() {
        siteCookies.surveyCookie();
    }
}
