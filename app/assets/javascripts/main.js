$(document).ready(function(){
  cookies.init();

  $( ".paypal-choice" ).click(function() {
	 $(".paypal-choice").hide();
	 $(".venmo-choice").hide();
	 $(".paypal-select").show();
	 $(".final-step").show();
	 $("#cash_out_cashout_type").val(1);
   });
  $( ".venmo-choice" ).click(function() {
	 $(".venmo-choice").hide();
	 $(".paypal-choice").hide();
	 $(".venmo-select").show()
	 $(".final-step").show();
	 $("#cash_out_cashout_type").val(0);
   });  
  $( ".back-choice" ).click(function() {
	 $(".venmo-choice").show();
	 $(".paypal-choice").show();
	 $(".venmo-select").hide();
	 $(".paypal-select").hide();
	 $(".final-step").hide();

   });
});
