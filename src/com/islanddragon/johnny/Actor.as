package com.islanddragon.johnny {
	import com.bensilvis.spriteSheet.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	public class Actor extends Sprite {
		protected var _name:String;
		protected var holder:Sprite;
		protected var b:Bitmap;
		protected var isSpriteSheet:Boolean = false;
		protected var spriteSheet:SpriteSheet;

		public function Actor(name:String, b:Bitmap, w:int = 0, h:int = 0) {
			this._name = name;
			holder = new Sprite();
			
			if (w !== 0 && h !== 0) {
				spriteSheet = new SpriteSheet(b, w, h);
				b = new Bitmap(new BitmapData(1, 1));
				isSpriteSheet = true;
			} else {
				this.b = b;
			}

			addChild(holder);
			holder.addChild(b);
		}

		public function draw():void {
			holder.removeChildAt(0);
			var b:Bitmap = new Bitmap(spriteSheet.drawTile(1));
			holder.addChild(b);
		}
	}
}
