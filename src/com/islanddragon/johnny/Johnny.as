package com.islanddragon.johnny {
	import com.bensilvis.spriteSheet.SpriteSheet;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.Event;

	/**
	 * ...
	 * @author Raidel del Peso
	 */
	internal class Johnny {
		
		protected var johnny_step:int;
		protected var stage:Sprite;
		protected var johnny:Bitmap;
		protected var timer:Timer;
		protected var ss:SpriteSheet;
		protected var prevPos:Point;
		protected var currPos:Point;
		protected var postPos:Point;
		protected var called:int;
		protected var loaded:Boolean;
		protected var speed:Number;
		protected var points:Array = [];
		protected var johnny_center_point:Point;
		
		public function Johnny(stage:Sprite, johnny:Bitmap, timer:Timer, ss:SpriteSheet):void {
			this.stage = stage;
			this.johnny = johnny;
			this.johnny_center_point = new Point(-37.5, -65);
			this.timer = timer;
			this.ss = ss;
			johnny_step = 0;
			called = 0;
			loaded = false;
			speed = 2;
			points.push(new Point(248,265));
			points.push(new Point(364,243));
			points.push(new Point(442,261));
			points.push(new Point(360,271));
		}
		
		public function update(e:Event):void {
			if (called < 5) {
				called++;
				return;
			}

			if (loaded) {
				draw();
			} else {
				loadJohnny();
			}
			called = 0;
		}
		
		public function walkTo(p:Point, s:Number):void {
			if (prevPos.x != currPos.x && prevPos.y != currPos.y) {
				return;
			}

			prevPos = currPos;
			postPos = p.clone();
			speed = s;
		}
		
		protected function loadJohnny():void {
			if (ss === null) {
				return;
			}

			if (johnny.width === 0 && johnny.height === 0) {
				johnny = new Bitmap(ss.drawTile(johnny_step));
				stage.addChild(johnny);
				prevPos = new Point(points[0].x, points[0].y);
				currPos = new Point(points[0].x, points[0].y);
				postPos = new Point(points[0].x, points[0].y);
				johnny.x = points[0].x + johnny_center_point.x;
				johnny.y = points[0].y + johnny_center_point.y;
				loaded = true;
			}
		}
		
		protected function draw():void {
			if (currPos.x > postPos.x - 1 && currPos.x < postPos.x + 1
				&& currPos.y > postPos.y - 1 && currPos.y < postPos.y + 1) {
				currPos.x = postPos.x;
				currPos.y = postPos.y;

				var p:int = Math.round(Math.random() * (points.length-1));
				trace(p);
				walkTo(points[p], 2);
				return;
			}


			var moveVector:Point = new Point(postPos.x - currPos.x, postPos.y - currPos.y);
			moveVector.normalize(speed);
			currPos.x += moveVector.x;
			currPos.y += moveVector.y;
			
			johnny.x = currPos.x + johnny_center_point.x;
			johnny.y = currPos.y + johnny_center_point.y;

			var offset:int = (moveVector.y < 0) ? 0 : 6;
			if (johnny_step > 5) {
				johnny_step = 0;
			}
			johnny.bitmapData = ss.drawTile(johnny_step + offset);
			johnny_step++;
		}
	}

}
