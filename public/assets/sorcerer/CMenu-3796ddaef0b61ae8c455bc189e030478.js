function CMenu(){var e,t,i,n;this._init=function(){e=new createjs.Bitmap(s_oSpriteLibrary.getSprite("bg_menu")),s_oStage.addChild(e);var o=s_oSpriteLibrary.getSprite("but_bg");if(t=new CTextButton(CANVAS_WIDTH/2,CANVAS_HEIGHT-100,o,TEXT_PLAY,"Chewy","#ffffff",40),t.addEventListener(ON_MOUSE_UP,this._onButPlayRelease,this),DISABLE_SOUND_MOBILE===!1||s_bMobile===!1){var o=s_oSpriteLibrary.getSprite("audio_icon");i=new CToggle(CANVAS_WIDTH-o.width/2+20,o.height/2+20,o),i.addEventListener(ON_MOUSE_UP,this._onAudioToggle,this),s_oSoundtrack=createjs.Sound.play("soundtrack",{loop:100})}n=new createjs.Shape,n.graphics.beginFill("black").drawRect(0,0,CANVAS_WIDTH,CANVAS_HEIGHT),s_oStage.addChild(n),createjs.Tween.get(n).to({alpha:0},1e3).call(function(){n.visible=!1})},this.unload=function(){t.unload(),t=null,(DISABLE_SOUND_MOBILE===!1||s_bMobile===!1)&&(i.unload(),i=null),s_oStage.removeChild(e),e=null,s_oStage.removeChild(n),n=null},this._onButPlayRelease=function(){this.unload(),s_oMain.gotoGame()},this._onAudioToggle=function(){createjs.Sound.setMute(!s_bAudioActive)},this._init()}