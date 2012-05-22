package com.islanddragon.johnny 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Raidel del Peso
	 */
	public class Waves extends Sprite
	{
		protected var w:Array;
		protected var wave:Bitmap = new Bitmap();
		
		public function Waves() 
		{
			addChild(wave);
		}
		
		public function addWave(wave:Bitmap):void {
			if (w.indexOf(wave) === 0) {
				w.push(wave);
			}
		}
		
		public function update(e:Event):void {
			trace('update waves');
		}
	}

}