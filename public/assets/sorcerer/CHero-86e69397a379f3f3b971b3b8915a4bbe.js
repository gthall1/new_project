function CHero(){var t,e,n,a,i,r,o,l,h,s,g=!1;this._init=function(){var n=s_oSpriteLibrary.getSprite("hero");s=new createjs.Container,s.regX=n.width/2,s.regY=n.height/2,s_oStage.addChild(s),o=new createjs.Bitmap(n),o.x=0,o.y=0,s.addChild(o),l=new createjs.Shape,l.graphics.beginFill("rgba(255,0,0,0.01)").drawCircle(40,110,16),s.addChild(l),h=new createjs.Shape,h.graphics.beginFill("rgba(255,0,0,0.01)").drawCircle(120,60,6),s.addChild(h),t=n.width,e=n.height},this.reset=function(t,e){n=e,void 0!==i&&null!==i&&i.unload(),void 0!==r&&null!==r&&r.unload(),s.x=t.x,s.y=t.y,a=new Array;for(var o=0;n>o;o++)a[o]=!0},this.unload=function(){},this.rotate=function(t){s.rotation=t},this.start=function(){i=this._getRandomBall(),i.changePos(t/2-25,e/2+20),i.getSprite().mask=l,r=this._getRandomBall(),r.changePos(120,e/2-12),r.getSprite().mask=h;var n=this;createjs.Tween.get(i.getSprite()).to({y:i.getY()+25},300).call(function(){n._onBallReady()}),createjs.Tween.get(r.getSprite()).to({y:r.getY()+16},300)},this._getRandomBall=function(){var t;if(this._checkIfAllColorsNotAvailable()===!0)return null;do{var e=Math.floor(Math.random()*n),i=!1;if(a[e]===!0){t=new CBall(e,s),i=!0;break}}while(i===!1);return t},this._checkIfAllColorsNotAvailable=function(){for(var t=!0,e=0;e<a.length;e++)a[e]===!0&&(t=!1);return t},this._nextShoot=function(){null!==i&&i.unload(),i=r,i.changePos(t/2-25,e/2+20),i.getSprite().mask=l,r=this._getRandomBall(),r.changePos(120,e/2-12),r.getSprite().mask=h;var n=this;createjs.Tween.get(i.getSprite()).to({y:i.getY()+25},300).call(function(){n._onBallReady()}),createjs.Tween.get(r.getSprite()).to({y:r.getY()+16},300)},this.colorCleared=function(n){a[n]=!1,i.getIndex()===n&&(i.unload(),i=this._getRandomBall(),null!==i&&(i.changePos(t/2-25,e/2+45),i.getSprite().mask=l)),r.getIndex()===n&&(r.unload(),r=this._getRandomBall(),null!==r&&(r.changePos(120,e/2+4),r.getSprite().mask=h))},this._onBallReady=function(){g=!0},this.getCurrentBall=function(){g=!1;var t=i;return this._nextShoot(),t},this.getX=function(){return s.x},this.getY=function(){return s.y},this.getRotation=function(){return s.rotation},this.canShoot=function(){return g},this._init()}