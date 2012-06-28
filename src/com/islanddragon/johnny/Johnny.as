package com.islanddragon.johnny 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	public class Johnny extends Actor
	{
		public function Johnny(director:Director, name:String, b:Bitmap, w:int=0, h:int=0) {
			super(director, name, b, w, h);
			this.animations['idleLeft'] = {
				'loop': true,
				'flipped': true,
				'sequence': [3,4]
			};
			
			this.animations['idleRight'] = {
				'loop': true,
				'flipped': false,
				'sequence': [3,4]
			};

			this.animations['walkBackLeft'] = {
				'loop': true,
				'flipped': true,
				'sequence': [21, 22, 23, 24, 25, 26]
			};
			
			this.animations['walkBackRight'] = {
				'loop': true,
				'flipped': false,
				'sequence': [21, 22, 23, 24, 25, 26]
			};
			
			this.animations['walkFrontLeft'] = {
				'loop': true,
				'flipped': false,
				'sequence': [27, 28, 29, 30, 31, 32]
			};
			
			this.animations['walkFrontRight'] = {
				'loop': true,
				'flipped': true,
				'sequence': [27, 28, 29, 30, 31, 32]
			};

			this.animations['climb'] = {
				'loop': true,
				'flipped': false,
				'sequence': [0, 1, 2]
			};

			this.animations['peek'] = {
				'loop': false,
				'flipped': false,
				'sequence': [14, 15]
			};

			this.animations['jump'] = {
				'loop': false,
				'flipped': false,
				'sequence': [5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 10, 11, 12, 13]
			};

			this.animations['swim'] = {
				'loop': true,
				'flipped': false,
				'sequence': [17, 18, 19, 20]
			};

			this.animations['walkOffWater'] = {
				'loop': true,
				'flipped': false,
				'sequence': [33, 34, 35, 36]
			};
		}
		
		public override function draw():void {
			if (isSpriteSheet === false) {
				return;
			}

			holder.removeChildAt(0);
			var b:Bitmap = new Bitmap(spriteSheet.drawTile(Math.round(Math.random() * 11)));
			holder.addChild(b);
			translateHolder();
			
			super.draw();
		}
		
		public override function translate(params:Object, delay:int):void {
			super.translate(params, delay);

			if (animatedState === 'walk') {
				var hor:String = 'Left';
				var ver:String = 'Back';

				if (direction.x > 0) {
					hor = 'Right';
				}
				
				if (direction.y > 0) {
					ver = 'Front';
				}
				
				animatedState = 'walk' + ver + hor;
			}
		}
	}

}