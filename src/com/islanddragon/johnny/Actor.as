package com.islanddragon.johnny {
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public class Actor extends Prop {
		protected var nextPosition:Point = new Point();
		protected var direction:Point = new Point();
		protected var speed:int = 4;
		protected var wait:int = 0;
		protected var animations:Object = {};
		protected var animatedState:String = 'idleRight';
		protected var prevAnimatedState:String = 'idleRight';
		protected var animatedFrame:int = 0;

		public function Actor(name:String, b:Bitmap, w:int=0, h:int=0) {
			super(name, b, w, h);
		}

		public override function draw():void {
			translateHolder();
			runAnimation();
			update();
		}
		
		public override function update():void {
			super.update();
			var a:Boolean = updateWait();
			var b:Boolean = updateMove();
			
			busy = (a || b);
			return;
		}
	
		public function runAnimation():void {
			if (isSpriteSheet === false) {
				return;
			}

			if (prevAnimatedState != animatedState) {
				animatedFrame = 0;
			}
			
			holder.removeChildAt(0);
			var b:Bitmap = new Bitmap(spriteSheet.drawTile(animations[animatedState]['sequence'][animatedFrame], animations[animatedState]['flipped']));
			if (animatedFrame >= animations[animatedState]['sequence'].length - 1) {
				if (animations[animatedState]['loop'] === true) {
					animatedFrame = 0;
				}
			} else {
				animatedFrame++;
			}
			holder.addChild(b);
			prevAnimatedState = animatedState;
		}
		
		public function translate(params:Object, delay:int):void {
			var s:int = (params.hasOwnProperty('speed')) ? params.speed : speed;
			var a:String = (params.hasOwnProperty('animation')) ? params.animation : 'walk';
			
			nextPosition = new Point(params.x, params.y);
			direction = new Point(nextPosition.x - position.x, nextPosition.y - position.y);
			direction.normalize(s);
			animatedState = a;
			busy = true;
		}

		public function idle(params:Object, delay:int):void {
			if (params.hasOwnProperty('x') &&  params.hasOwnProperty('y')) {
				teleport(params, delay);
			}

			animatedState = (params.hasOwnProperty('animation')) ? params.animation : 'idle';
			wait = (params.hasOwnProperty('wait')) ? params.wait : 0;
			busy = true;
		}
		
		public function teleport(params:Object, delay:int):void {
			position.x = nextPosition.x = params.x;
			position.y = nextPosition.y = params.y;
			busy = true;
		}
		
		public function animate(params:Object, delay:int):void {
			animatedState = params.animatedState;
		}
		
		public function updateWait():Boolean {
			if (wait === 0) {
				return false;
			}

			wait--;
			return true;
		}
		
		public function updateMove():Boolean {
			if (position.x === nextPosition.x && position.y === nextPosition.y) {
				return false;
			}

			var movedX:Boolean = true;
			var movedY:Boolean = true;
			
			if ((direction.x > 0 && position.x >= nextPosition.x) || (direction.x < 0 && position.x <= nextPosition.x) || direction.x === 0) {
				movedX = false;
			}
			if ((direction.y > 0 && position.y >= nextPosition.y) || (direction.y < 0 && position.y <= nextPosition.y) || direction.y === 0) {
				movedY = false;
			}

			if (movedX === false && movedY === false) {
				position = new Point(nextPosition.x, nextPosition.y);
				return false;
			}
			
			position.x += direction.x;
			position.y += direction.y;
			
			return true;
		}
	}
}
