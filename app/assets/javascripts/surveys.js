var survey = {
    conf: {
        surveyAnswer: ".condition .js-survey__answer",
        answered: false
    },

    bind: function() {
        var self = this;

        $(this.conf.surveyAnswer).on('change', function(){
            var answerIsYes = $(this).closest('label').hasClass('yes');

            if (self.conf.answered === false) {
                if (answerIsYes) {
                    $('.js-survey__question.yes-answer').fadeIn();
                } else {
                    $('.js-survey__question.no-answer').fadeIn();
                }

                $('.condition .js-survey__answer').attr('disabled','true');
            }

            self.conf.answered = true;
        });
    },

    init: function() {
        survey.bind();
    },
};
