function CExtraScore(e,t,i){var r;this._init=function(e,t,i){var a=s_oSpriteLibrary.getSprite("extra_score");r=new createjs.Bitmap(a),r.x=e,r.y=t,r.regX=a.width/2,r.regY=a.height/2,r.alpha=0,i.addChild(r),createjs.Tween.get(r).to({alpha:1},1e3).call(function(){i.removeChild(r)})},this._init(e,t,i)}