package com.islanddragon.johnny 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	public class Waves extends Actor
	{
		public function Waves(director:Director, name:String, b:Bitmap, w:int=0, h:int=0) {
			super(director, name, b, w, h);
			this.animations['idle'] = {
				'loop': true,
				'flipped': false,
				'sequence': [0, 0, 1, 1, 2, 2, 1, 1]
			};
			
			animatedState = 'idle';
			prevAnimatedState = 'idle';
		}
	}

}