package com.islanddragon.johnny {
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	public class Actor extends Prop {
		protected var nextPosition:Point = new Point();
		protected var direction:Point = new Point();
		protected var speed:int = 5;

		public function Actor(name:String, b:Bitmap, w:int=0, h:int=0) {
			super(name, b, w, h);
		}

		protected override function update():void {
			super.update();

			var moved:Boolean = move();
			if (moved === false) {
				busy = false;
			}
		}

		protected function walk(params:Object, delay:int):void {
			nextPosition = new Point(params.x, params.y);
			direction = new Point(nextPosition.x - position.x, nextPosition.y - position.y);
			direction.normalize(speed);
		}
		
		protected function teleport(params:Object, delay:int):void {
			position.x = nextPosition.x = params.x;
			position.y = nextPosition.y = params.y;
			translateHolder();
		}
		
		protected function move():Boolean {
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
