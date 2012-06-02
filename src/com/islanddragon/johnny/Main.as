package com.islanddragon.johnny {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextSnapshot;

	[Frame(factoryClass="com.islanddragon.johnny.Preloader")]
	public class Main extends Sprite {
		public function Main():void {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(e:Event = null):void {
			var dir:Director = new Director(stage);
			dir.loadAssets();
			stage.addChild(dir);
			return;
		}
	}
	
}
