package com.islanddragon.johnny {
	import com.bensilvis.spriteSheet.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	public class Prop extends Sprite {
		protected var _name:String;
		protected var holder:Sprite;
		protected var b:Bitmap;
		protected var isSpriteSheet:Boolean = false;
		protected var spriteSheet:SpriteSheet;
		protected var busy:Boolean = false;
		protected var executions:int = 0;
		protected var position:Point = new Point();
		protected var centerPoint:Point = new Point();

		public function Prop(name:String, b:Bitmap, w:int = 0, h:int = 0) {
			this._name = name;
			holder = new Sprite();
			
			if (w !== 0 && h !== 0) {
				spriteSheet = new SpriteSheet(b, w, h);
				b = new Bitmap(new BitmapData(1, 1));
				isSpriteSheet = true;
				centerPoint = new Point(37.5, 65);
			} else {
				this.b = b;
			}

			addChild(holder);
			holder.addChild(b);
		}

		public function draw():void {
			update();

			if (isSpriteSheet === false) {
				return;
			}

			holder.removeChildAt(0);
			var b:Bitmap = new Bitmap(spriteSheet.drawTile(Math.round(Math.random() * 11)));
			holder.addChild(b);
			translateHolder();
		}
		
		protected function translateHolder():void {
			holder.x = position.x - centerPoint.x;
			holder.y = position.y - centerPoint.y;
		}
		
		protected function update():void {
			if (isSpriteSheet === false) {
				return;
			}
			busy = false;
		}
		
		public function isBusy():Boolean {
			return busy;
		}
		
		public function trigger(action:String, params:Object, delay:int):Boolean {
			if (this[action] === null) {
				return false;
			}

			this[action](params, delay);
			busy = true;
			return true;
		}

		protected function moveToFront(params:Object, delay:int):void {
			stage.addChild(this);
		}

		protected function moveBack(params:Object, delay:int):void {
			var cur_depth:int = stage.getChildIndex(this);
			stage.addChildAt(this, cur_depth - params.times);
		}
		
		protected function moveForward(params:Object, delay:int):void {
			var cur_depth:int = stage.getChildIndex(this);
			stage.addChildAt(this, cur_depth + params.times);
		}
	}
}
