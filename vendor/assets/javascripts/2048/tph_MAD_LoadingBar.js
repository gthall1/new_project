function RenderLoadingBar_Standard(_graphics, _width,_height, _total, _current, _loadingscreen) 
{
		var barwidth = (_width / 100) * 40;				
		var barheight = 15;                             
		var x = (_width - barwidth) / 2;				
		var y = 10 + (_height - barheight) *0.75;			
		var w = (barwidth / _total) * _current;
	_graphics.fillStyle = "rgba(255,255,255,255)";
	_graphics.fillRect(0, 0, _width, _height);
	
	if (_loadingscreen)
	{
		//draw splash.png image
		_graphics.drawImage(_loadingscreen, 0, 0, 525, 800);
	} 

	if (_current != 0)
	{

		_graphics.fillRect(x, y, barwidth, barheight);
		_graphics.fillStyle = "rgba(60,255,60,255)";
		_graphics.fillRect(x, y, w, barheight);
	}
}


