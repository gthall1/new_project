function CGfxButton(t,n,i){var e,s,o,u=[];return this._init=function(t,n,i){e=new Array,s=new Array,o=new createjs.Bitmap(i),o.x=t,o.y=n,o.regX=i.width/2,o.regY=i.height/2,s_oStage.addChild(o),this._initListener()},this.unload=function(){o.off("mousedown",this.buttonDown),o.off("pressup",this.buttonRelease),s_oStage.removeChild(o)},this.setVisible=function(t){o.visible=t},this._initListener=function(){o.on("mousedown",this.buttonDown),o.on("pressup",this.buttonRelease)},this.addEventListener=function(t,n,i){e[t]=n,s[t]=i},this.addEventListenerWithParams=function(t,n,i,o){e[t]=n,s[t]=i,u=o},this.buttonRelease=function(){(DISABLE_SOUND_MOBILE===!1||s_bMobile===!1)&&createjs.Sound.play("press_but"),o.scaleX=1,o.scaleY=1,e[ON_MOUSE_UP]&&e[ON_MOUSE_UP].call(s[ON_MOUSE_UP],u)},this.buttonDown=function(){o.scaleX=.9,o.scaleY=.9,e[ON_MOUSE_DOWN]&&e[ON_MOUSE_DOWN].call(s[ON_MOUSE_DOWN],u)},this.setPosition=function(t,n){o.x=t,o.y=n},this.setX=function(t){o.x=t},this.setY=function(t){o.y=t},this.getButtonImage=function(){return o},this.getX=function(){return o.x},this.getY=function(){return o.y},this._init(t,n,i),this}