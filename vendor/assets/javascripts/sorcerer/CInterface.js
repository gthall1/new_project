function CInterface(){
    var _oScoreText;
    var _oButExit;
    var _oHitArea;
    var _oAudioToggle;
    var _oEndPanel;
    var _oNextLevelPanel;
    
    this._init = function(){
        
        _oScoreText = new createjs.Text(TEXT_SCORE +" 0","bold 38px Chewy", "#fff");
        _oScoreText.x = 10;
        _oScoreText.y = 10;
        _oScoreText.textAlign = "left";
        s_oStage.addChild(_oScoreText);
        
        var oParent = this;
	_oHitArea = new createjs.Bitmap(s_oSpriteLibrary.getSprite('hit_area'));
        s_oStage.addChild(_oHitArea);
	_oHitArea.on("pressup",function(evt){oParent._onTapScreen(evt.stageX,evt.stageY)}); 
        
        var oSprite = s_oSpriteLibrary.getSprite('but_exit');
        _oButExit = new CGfxButton(CANVAS_WIDTH - (oSprite.width/2) - 10,(oSprite.height/2) + 10,oSprite,true);
        _oButExit.addEventListener(ON_MOUSE_UP, this._onExit, this);
        
        if(DISABLE_SOUND_MOBILE === false || s_bMobile === false){
            _oAudioToggle = new CToggle(_oButExit.getX() - oSprite.width,(oSprite.height/2) + 10,s_oSpriteLibrary.getSprite('audio_icon'));
            _oAudioToggle.addEventListener(ON_MOUSE_UP, this._onAudioToggle, this);
        }
        
        _oNextLevelPanel = new CNextLevel();
        _oEndPanel = new CEndPanel(s_oSpriteLibrary.getSprite('msg_box'));
    };
    
    this.unload = function(){
        _oButExit.unload();
        _oButExit = null;

        if(DISABLE_SOUND_MOBILE === false){
            _oAudioToggle.unload();
            _oAudioToggle = null;
        }

        s_oStage.removeAllChildren();
    };
    
    this._onTapScreen = function(iX,iY){
        s_oGame.onShot(iX,iY);
    };
    
    this.gameOver = function(iScore){
        _oEndPanel.show(iScore,false);
    };
    
    this.win = function(iScore){
        _oEndPanel.show(iScore,true);
    };
    
    this.nextLevel = function(iLevel,iScore){
        _oNextLevelPanel.show(iLevel,iScore);
    };
    
    this.refreshScore = function(iScore){
        
      var token = $("#game_token").val();
      $.ajax({
        type: "GET",
        url: "/score_update",
        data: { token: token, score: iScore },
        success:function(data) {
            $('.credits').html(data.user_total + ' credits');
        }
      });       
      
      _oScoreText.text = TEXT_SCORE +" "+iScore; //stock
    };
    
    this._onExit = function(){
        s_oGame.onExit();  
    };
    
    this._onAudioToggle = function(){
        createjs.Sound.setMute(!s_bAudioActive);
    };

    s_oInterface = this;
    
    this._init();
    
    return this;
}

var s_oInterface;