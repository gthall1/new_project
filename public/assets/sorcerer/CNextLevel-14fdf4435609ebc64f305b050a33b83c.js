function CNextLevel(){var e,t,i,n,s,x;this._init=function(){e=new createjs.Bitmap(s_oSpriteLibrary.getSprite("msg_box")),e.x=0,e.y=0,i=new createjs.Text("","bold 58px Chewy","#000"),i.x=CANVAS_WIDTH/2+32,i.y=CANVAS_HEIGHT/2-138,i.textAlign="center",t=new createjs.Text("","bold 58px Chewy","#ffffff"),t.x=CANVAS_WIDTH/2+30,t.y=CANVAS_HEIGHT/2-140,t.textAlign="center",s=new createjs.Text("","bold 44px Chewy","#000"),s.x=CANVAS_WIDTH/2+32,s.y=CANVAS_HEIGHT/2+40,s.textAlign="center",n=new createjs.Text("","bold 44px Chewy","#ffffff"),n.x=CANVAS_WIDTH/2+30,n.y=CANVAS_HEIGHT/2+38,n.textAlign="center",x=new createjs.Container,x.alpha=0,x.visible=!1,x.addChild(e,i,t,s,n),s_oStage.addChild(x)},this.show=function(e,o){i.text=TEXT_LEVEL+" "+e,t.text=TEXT_LEVEL+" "+e,s.text=TEXT_SCORE+" "+o,n.text=TEXT_SCORE+" "+o,x.visible=!0;var a=this;createjs.Tween.get(x).to({alpha:1},500).call(function(){a._initListener()})},this._initListener=function(){x.on("mousedown",this._onExit)},this._onExit=function(){x.off("mousedown"),x.alpha=0,x.visible=!1,s_oGame.nextLevel()},this._init()}