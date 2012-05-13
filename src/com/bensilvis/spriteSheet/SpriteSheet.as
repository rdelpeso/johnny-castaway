package com.bensilvis.spriteSheet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;

	public class SpriteSheet extends Sprite
	{
		private var tileSheetBitmapData:BitmapData;
		private var canvasBitmapData:BitmapData;

		private var tileWidth:int;
		private var tileHeight:int;
		private var rowLength:int;

		private var tileRectangle:Rectangle;
		private var tilePoint:Point;

		public function SpriteSheet(tileSheetBitmap:Bitmap, width:Number = 16, height:Number = 16)
		{
			tileSheetBitmapData = tileSheetBitmap.bitmapData;
			tileWidth = width;
			tileHeight = height;

			rowLength = int(tileSheetBitmap.width / width);

			tileRectangle = new Rectangle(0, 0, tileWidth, tileHeight);
			tilePoint = new Point(0, 0);

			canvasBitmapData = new BitmapData(tileWidth, tileHeight, true);
			var canvasBitmap:Bitmap = new Bitmap(canvasBitmapData);
			addChild(canvasBitmap);

			drawTile(0);

			addEventListener(Event.REMOVED_FROM_STAGE, remove);
		}

		public function drawTile(tileNumber:int, flipped:Boolean = false):BitmapData
		{
			tileRectangle.x = int((tileNumber % rowLength)) * tileWidth;
			tileRectangle.y = int((tileNumber / rowLength)) * tileHeight;
			canvasBitmapData.copyPixels(tileSheetBitmapData, tileRectangle, tilePoint);
	
			var bitmatData:BitmapData = canvasBitmapData.clone();
			
			if (flipped) {
				var flipHorizontalMatrix:Matrix = new Matrix()
				flipHorizontalMatrix.scale(-1,1)
				flipHorizontalMatrix.translate(bitmatData.width,0)
				
				var flippedBitmap:BitmapData = new BitmapData(bitmatData.width, bitmatData.height, true, 0xFFFFFF);
				flippedBitmap.draw(bitmatData, flipHorizontalMatrix);
				return flippedBitmap;
			}
			return bitmatData;
		}

		public function tileBoard(boardIndex:Array):BitmapData
		{
			var wide:int = boardIndex[0].length;
			var tall:int = boardIndex.length;

			canvasBitmapData = new BitmapData((tileWidth * wide), (tileHeight * tall), true);
			var boardCanvas:Bitmap = Bitmap(getChildAt(0));
			boardCanvas.bitmapData = canvasBitmapData;

			tileRectangle = new Rectangle(0, 0,(tileWidth * wide), (tileHeight * tall));
			for (var i:int = 0; i < wide; i++) {
				for (var j:int = 0; j < tall; j++) {
					tilePoint = new Point((tileWidth * i), (tileHeight * j));

					drawTile(boardIndex[j][i]);
				}
			}
			return canvasBitmapData.clone();
		}

		public function remove(e:Event):void {
			tileSheetBitmapData.dispose();
			canvasBitmapData.dispose();
		}
	}
}