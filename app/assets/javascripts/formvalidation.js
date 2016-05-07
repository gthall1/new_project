var formValidation = {
    selections: {
        requiredField: 'input[required]',
        emailField : 'input[type="email"]',
        requiredError: '.js-form__required'
    },

    conf: {
        nameMin: 2
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

    bind: function() {
        // Sign in form loading
        $('.js-form-submit').click(function(){
          $('.fa-refresh').removeClass('hidden');
          $('.fa-refresh').addClass('rotate');
          $('.fa-arrow-circle-right').addClass('hidden');
        });

        $(formValidation.selections.requiredField).blur(function(e){
            var $this = $(this),
                $form = $this.parents('form'),
                minVal = $this.attr('min') || 2;

            if ($this.val().length >= minVal) {
                $this.siblings(formValidation.selections.requiredError).removeClass('show');
                $form.removeClass('js-prevent-form');
            } else {
                $form.addClass('js-prevent-form');
                $this.siblings(formValidation.selections.requiredError).addClass('show');
            }
        });

        $(formValidation.selections.emailField).blur(function(e){
            // consolidate email validation
        });

        $('.js-validate--name').blur(function(e){
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
                    } else {
                        $('.js-valid--name').removeClass('show');
                        $('.js-invalid--name .js-error-case').hide();

                        if (!isAvailable){
                            $('.js-invalid--name .js-error-case--taken').show();
                        } else if (name.length <= 0) {
                            $('.js-invalid--name .js-error-case--invalid').show();
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
        $('.js-validate--email').blur(function(e){
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
                        } else {
                            $('.js-valid--email').removeClass('show');
                            $('.js-invalid--email .js-error-case').hide();

                            if (!isValid && isAvailable) {
                                $('.js-invalid--email .js-error-case--invalid').show();

                            } else if (isValid && !isAvailable) {
                                $('.js-invalid--email .js-error-case--taken').show();
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
