$(document).ready(function(){
  //cookies.init();

  app.init();
  $( ".paypal-choice" ).click(function() {
    $('.page-title').html('Paypal Details');
  	 $(".back-link").hide();
  	 $(".back-choice").show();
	 $(".paypal-choice").hide();
	 $(".venmo-choice").hide();
	 $(".paypal-select").show();
	 $(".final-step").show();
	 $("#cash_out_cashout_type").val(1);
   });
  $( ".venmo-choice" ).click(function() {
    $('.page-title').html('Venmo Details');
  	 $(".back-link").hide();
  	 $(".back-choice").show();
	 $(".venmo-choice").hide();
	 $(".paypal-choice").hide();
	 $(".venmo-select").show()
	 $(".final-step").show();
	 $("#cash_out_cashout_type").val(0);
   });
  $( ".back-choice" ).click(function() {
    $('.page-title').html('Cash Type');
  	 $(".back-link").show();
  	 $(".back-choice").hide();
	 $(".venmo-choice").show();
	 $(".paypal-choice").show();
	 $(".venmo-select").hide();
	 $(".paypal-select").hide();
	 $(".final-step").hide();
   });
});
