$(document).ready(function(){
	$( ".random-user-but" ).click(function() {
		$.ajax({
		  type: "GET",
		  url: "/ro"
		})
	});
	
	$(".challenged-user").click(function(){
		$('#challenge_challenged_user_id').val($(this).data("user-id"));
		$('#challenge_challenged_user_id').val($(this).data("user-id"));
		$('.challenged-user-name').html($(this).data("user-name"));
		$('.pre-challenge').show();
		$('.challenge-choice').hide();		
	});

});

