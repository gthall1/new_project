var formValidation = {
    selections: {
        requiredField: '.js-validate-input',
        valUsernameField: '.js-validate--name',
        valEmailField: '.js-validate--email',
        requiredError: '.js-form__required',
        formSubmitBtn: '.js-form-submit'
    },

    conf: {
        nameMin: 1,
        minAge: 13
    },

    validateDateFormat: function (testdate) {
        var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/ ;
        return date_regex.test(testdate);
    },

    validateEmail: function (email) {
        var re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    },

    preventSubmission: function() {
        $('.js-prevent-form').one('submit', function(e) {
            e.preventDefault();
            return false;
        })
    },

    prepareReqFields: function() {
        $('input[required]').after('<span class="js-form__required form__required">required</span>');
    },

    validAge: function(date, minAge) {
        var today = new Date(),
            dateArr = date.split('/'),
            date = new Date (dateArr[2], dateArr[0] - 1, dateArr[1]),
            msecInYear = 31557600000,
            age = Math.floor((today - date)/msecInYear);

        return age > minAge;
    },

    checkNewUserbirthday: function(e) {
        var birthday = $('.js-validate-date').val();

        if (formValidation.validAge(birthday, formValidation.conf.minAge)) {
            if (!formValidation.validateDateFormat(birthday)) {
                e.preventDefault();
                formValidation.setValidationBarMsg('Please correct format: MM/DD/YYYY');
            } else if (birthday === "") {
                e.preventDefault();
                formValidation.setValidationBarMsg('Please fill in birthday');
            } else {
                formValidation.hideValidationBar();
            }
        } else {
            e.preventDefault();
            formValidation.setValidationBarMsg('Must be at least ' + formValidation.conf.minAge + ' years old')
        }
    },

    setValidationBarMsg: function(err) {
        $('.js-form-error__item').text(err);

        formValidation.showValidationBar();
    },

    showValidationBar: function() {
        $('.js-form-errors-bar').addClass('show');
    },

    hideValidationBar: function() {
        $('.js-form-errors-bar').removeClass('show');
    },

    bind: function() {
        self = this;

        $('.js-form-validate-date').on('submit', function(e) {
            formValidation.checkNewUserbirthday(e);
        });

        $('.js-form-errors-bar').on('click', function() {
            formValidation.hideValidationBar();
        });

        // Sign in form loading
        $(formValidation.selections.formSubmitBtn).click(function(){
          $('.fa-refresh').removeClass('hidden');
          $('.fa-refresh').addClass('rotate');
          $('.fa-arrow-circle-right').addClass('hidden');
        });

        $(formValidation.selections.requiredField).blur(function(e){
            var $this = $(this),
                $form = $this.parents('form'),
                minVal = $this.attr('min') || formValidation.conf.nameMin;

            if ($this.val().length >= minVal) {
                $this.siblings(formValidation.selections.requiredError).removeClass('show');
                $form.removeClass('js-prevent-form');
            } else {
                $form.addClass('js-prevent-form');
                $this.siblings(formValidation.selections.requiredError).addClass('show');
            }
        });

        // Validate new username
        $(formValidation.selections.valUsernameField).blur(function(e){
            var name = $(this).val();
            $.ajax({
                type: "GET",
                url: window.location.origin + '/validate_name',
                data: {name: name},
                dataType: "json",
                success: function(data) {
                    var isAvailable = data.available,
                        $form = $('.js-validate-name').parents('form'),
                        name = data.name;

                    if (isAvailable && name.length > 0) {
                        $('.js-invalid--name').removeClass('show')
                        $('.js-valid--name').addClass('show');
                        $form.removeClass('js-prevent-form');
                        self.hideValidationBar();
                    } else {
                        $('.js-valid--name').removeClass('show');
                        $('.js-invalid--name .js-error-case').hide();

                        if (!isAvailable){
                            self.setValidationBarMsg('Username has already been taken');
                            // $('.js-invalid--name .js-error-case--taken').show();
                        } else if (name.length <= 0) {
                            // $('.js-invalid--name .js-error-case--invalid').show();
                            self.setValidationBarMsg('Please enter a username');
                        }

                        $('.js-invalid--name').addClass('show');
                        $form.addClass('js-prevent-form');
                    }
                },
                error: function(data) {
                    console.dir(data);
                }
            });
        });

        // Validate New User Email
        $(formValidation.selections.valEmailField).blur(function(e){
            var email = $(this).val();

            $.ajax({
                type: "GET",
                url: window.location.origin + '/validate_email',
                data: {email: email},
                dataType: "json",
                success: function(data) {
                    var isValid = formValidation.validateEmail(email),
                        isAvailable = data.available;

                        if (isValid && isAvailable) {
                            $('.js-invalid--email').removeClass('show');
                            $('.js-valid--email').addClass('show');
                            self.hideValidationBar();
                        } else {
                            $('.js-valid--email').removeClass('show');
                            $('.js-invalid--email .js-error-case').hide();

                            if (!isValid && isAvailable) {
                                self.setValidationBarMsg('Invalid email');
                            } else if (isValid && !isAvailable) {
                                self.setValidationBarMsg('Email has already been used');
                            }

                            $('.js-invalid--email').addClass('show');
                        }

                        if (!isValid || !isAvailable) {
                            $('.new_user').addClass('js-prevent-form');
                            formValidation.preventSubmission();
                        } else {
                            $('.new_user').removeClass('js-prevent-form');
                        }
                },
                error: function(data) {
                    console.dir(data);
                }
            });
        });
    },

    init: function() {
        formValidation.bind();
        formValidation.prepareReqFields();


    }
}
