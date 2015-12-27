$(document).ready(function(){
	$( ".random-user-but" ).click(function() {
		console.log('ruh-row');
		$.ajax({
		  type: "GET",
		  url: "/ro"
		})
	});
	
});