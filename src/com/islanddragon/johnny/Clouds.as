package com.islanddragon.johnny 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Raidel del Peso
	 */
	public class Clouds extends Sprite
	{
		protected var c:Array;

		public function Clouds() 
		{
			c = new Array();
		}
		
		public function addCloud(cloud:Bitmap):void {
			if (c.indexOf(cloud) === 0) {
				c.push(cloud);
			}
			addChild(cloud);
		}
		
		public function update(e:Event):void {
			trace('update clouds');
		}
	}

}