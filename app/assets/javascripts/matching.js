var tiles = new Array(),
	iFlippedTile = null,
	iTileBeingFlippedId = null,
	advertisers = new Array(),
	tileImage = new Array(),
	tileAllocation = null,
	iTimer = 0,
	iInterval = 100,
	iPeekTime = 3000,
	clockstop = true,
	matchcount = 0
	the_timer = null;

function getRandomImageForTile() {

	var iRandomImage = Math.floor((Math.random() * tileAllocation.length)),
		iMaxImageUse = 2;

	while(tileAllocation[iRandomImage] >= iMaxImageUse ) {
			
		iRandomImage = iRandomImage + 1;
			
		if(iRandomImage >= tileAllocation.length) {
				
			iRandomImage = 0;
		}
	}
	
	return iRandomImage;
}

function createTile(iCounter) {
	
	var curTile =  new tile("tile" + iCounter),
		iRandomImage = getRandomImageForTile();
		
	tileAllocation[iRandomImage] = tileAllocation[iRandomImage] + 1;
	image = "/assets/" +  (iRandomImage + 1) + ".jpg"
 	$.ajax({
      type: "GET",
      url: "/get_advertiser_logo",
      data: { id: advertisers[iRandomImage]}
    })
	.done(function( data ) {
		image = data.ad_image;
	});	
	tileImage[iRandomImage] = image
	
	curTile.setFrontColor("tileColor1");
	curTile.setStartAt(500 * Math.floor((Math.random() * 5) + 1));
	curTile.setBackContentImage(image);
	
	return curTile;
}

function initState() {

	/* Reset the tile allocation count array.  This
		is used to ensure each image is only 
		allocated twice.
	*/
	tileAllocation = new Array(0,0,0,0,0,0,0,0,0,0);
   
	while(tiles.length > 0) {
		tiles.pop();
	}
	
	$('#board').empty();
	iTimer = 0;
	
}
function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    clearInterval(the_timer);
    the_timer = setInterval(function () {
        minutes = parseInt(timer / 60, 00)
        seconds = parseInt(timer % 60, 00);

        minutes = minutes < 1 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.text(minutes + ":" + seconds);

        if (!clockstop && ++duration < 999) {
            timer = duration;
        }

    }, 1000);
}


function initTiles() {
    var time = 0,
	    iCounter = 0, 
		curTile = null,
	matchcount = 0;
	initState();
	clockstop = false;
 	$.ajax({
      type: "GET",
      url: "/reset_timer"
    })
	.done(function( data ) {
		if (data.status == "success"){
		    display = $('#time');
		    console.log(data.duration);
		    $('#game_token').val(data.token);
		    startTimer(data.duration, display);
		}
	});	
	 //console.log("ADVERTISER LENGTH IS "+ advertisers.length)

	// Randomly create twenty tiles and render to board
	//while(advertisers.length < 10){
	//	console.log("waiting for response")
	//}
	for(iCounter = 0; iCounter < 20; iCounter++) {
		
		curTile = createTile(iCounter);
		
		$('#board').append(curTile.getHTML());
		
		tiles.push(curTile);
	}	
}

function hideTiles(callback) {
	
	var iCounter = 0;

	for(iCounter = 0; iCounter < tiles.length; iCounter++) {
		
		tiles[iCounter].revertFlip();

	}
	
	callback();
}

function revealTiles(callback) {
	
	var iCounter = 0,
		bTileNotFlipped = false;

	for(iCounter = 0; iCounter < tiles.length; iCounter++) {
		
		if(tiles[iCounter].getFlipped() === false) {
		
			if(iTimer > tiles[iCounter].getStartAt()) {
				tiles[iCounter].flip();
			}
			else {
				bTileNotFlipped = true;
			}
		}
	}
	
	iTimer = iTimer + iInterval;

	if(bTileNotFlipped === true) {
		setTimeout("revealTiles(" + callback + ")",iInterval);
	} else {
		callback();
	}
}

function playAudio(sAudio) {
	
	var audioElement = document.getElementById('audioEngine');
			
	if(audioElement !== null) {

		audioElement.src = sAudio;
		audioElement.play();
	}	
}

function checkMatch() {
	
	if(iFlippedTile === null) {
		  
		iFlippedTile = iTileBeingFlippedId;

	} else {
		
		if( tiles[iFlippedTile].getBackContentImage() !== tiles[iTileBeingFlippedId].getBackContentImage()) {
			
			setTimeout("tiles[" + iFlippedTile + "].revertFlip()", 2000);
			setTimeout("tiles[" + iTileBeingFlippedId + "].revertFlip()", 2000);
			
			//playAudio("mp3/no.mp3"); kept in in case you want this

		} else {
			matchcount = matchcount + 1;
			if (matchcount == 10){
				victory();
			}
			//playAudio("mp3/applause.mp3"); maybe we will want this?
		}

		iFlippedTile = null;
		iTileBeingFlippedId = null;
	}
}
function victory(){
    var token = $("#game_token").val();
    $.ajax({
      type: "GET",
      url: "/memorywin",
      data: { token: token, match: matchcount,time_left:$('#time').html() }
    })
      .done(function( data ) {
        if(data.status == "success"){
            if(data.win === true){
                var credits = $("#credits").data("user-credits");
                clockstop = true;
                $(".outcome").html("You won "+data.earned + " credit(s) for a total of "+ data.total_credits +" credit(s) so far! Click 'New Game' again for another chance!")
                $("#credit_count").html(credits + data.total_credits);
                if(data.score){
                	$(".scorebox").html("Your new high score is " + data.score +"!");
                }
            }else{
            	clockstop= true;
                $(".outcome").html("Sorry you lost! So far you have earned "+ data.total_credits +" in this game session! Click again for another chance!")
            }
        }else if(data.status == "closed"){
            $(".outcome").html("Sorry this game has closed!");
        }
      });
}
function onPeekComplete() {

	$('div.tile').click(function() {
	
		iTileBeingFlippedId = this.id.substring("tile".length);
	
		if(tiles[iTileBeingFlippedId].getFlipped() === false) {
			tiles[iTileBeingFlippedId].addFlipCompleteCallback(function() { checkMatch(); });
			tiles[iTileBeingFlippedId].flip();
		}
	  
	});
}

function onPeekStart() {
	setTimeout("hideTiles( function() { onPeekComplete(); })",iPeekTime);
}



$(document).ready(function() {

	$('#startGameButton').click(function(event) {
		event.preventDefault();
	 	$.ajax({
	      type: "GET",
	      url: "/get_advertisers"
	    })
		.done(function( data ) {
			advertisers = data.advertisers;
			initTiles();
		});	
		setTimeout("revealTiles(function() { onPeekStart(); })",iInterval);

	});
});