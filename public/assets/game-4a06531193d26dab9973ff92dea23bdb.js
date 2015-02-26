$(document).ready(function(){
	$( ".play" ).click(function() {
		var token = $("#game_token").val();
		$.ajax({
		  type: "GET",
		  url: "/updates",
		  data: { token: token, button: "play" }
		})
		  .done(function( data ) {
		  	if(data.status == "success"){
			  	if(data.win === true){
			  		var credits = $("#credits").data("user-credits");
			  		$(".outcome").html("You win 1 credit for a total of "+ data.total_credits +" credit(s) so far! Click again for another chance!")
			  		$("#credit_count").html(credits + data.total_credits);
			  	}else{
			  		$(".outcome").html("Sorry you lost! So far you have earned "+ data.total_credits +" in this game session! Click again for another chance!")
			  	}
		  		if(data.partner_image != "none"){
		  			$(".ad-space").html("<img style='max-height:100px' src='"+data.partner_image +"' />");
		  		}
			}else if(data.status == "closed"){
				$(".outcome").html("Sorry this game has closed!");
			}
		  });
	});
});
