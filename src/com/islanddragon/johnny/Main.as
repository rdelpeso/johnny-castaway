package com.islanddragon.johnny {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.system.LoaderContext;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import org.as3commons.zip.*;

	/**
	 * ...
	 * @author Raidel del Peso
	 */
	[Frame(factoryClass="com.islanddragon.johnny.Preloader")]
	public class Main extends Sprite {
		[Embed(source = '../../../../lib/original.skin', mimeType = 'application/octet-stream')]
		private var originalSkin : Class;
		private var originalSkinData :ByteArray = new originalSkin() as ByteArray;

		protected var items:Object = new Object();
		protected var items_ordered:Array = new Array(
			'sky'
			, 'cloud_1'
			, 'cloud_2'
			, 'sea'
			, 'wave_1'
			, 'wave_2'
			, 'wave_3'
			, 'island'
			, 'palm_shadow'
			, 'palm_back'
			, 'palm_tree'
			, 'palm_coco'
			, 'palm_front'
		);
		protected var loaded_items:String = "";
		protected var display_txt:TextField;
		protected var elapsedTime:Timer = new Timer(20);
		protected var elapsedTimeFast:Timer = new Timer(20);
		protected var mc:MovieClip = new MovieClip();
		
		public function Main():void {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			display_txt = new TextField();
			display_txt.y = 400;
			display_txt.selectable = true;
			display_txt.multiline = true;
			display_txt.text = "asdasds";
			mc.addChild(display_txt);
			loadSkin();
			this.addEventListener(Event.ENTER_FRAME, process);
			elapsedTime.start();
			elapsedTimeFast.start();
			addChild(mc);
			
			var maskingShape:Shape = new Shape();
			maskingShape.graphics.lineStyle();
			maskingShape.graphics.beginFill(0xFFFFFF,1);
			maskingShape.graphics.drawRect(0,0,512,384);
			maskingShape.graphics.endFill();
			
			mc.mask = maskingShape;
		}
		
		protected function loadSkin(name:String = 'original'):void {
			var z:Zip = new Zip();
			z.loadBytes(originalSkinData);

			for (var i:Number = 0; i < z.getFileCount(); i++) {
				var ldr:Loader = new Loader();
				var zf:ZipFile = z.getFileAt(i);
				var key:String = zf.filename.replace('.png', '');
				loaded_items += key + "\n";
				ldr.loadBytes(zf.content);
				items[key] = ldr;
				mc.addChild(items[key]);
			}

			orderLayers();
			items['wave_1'].visible = true;
			items['wave_2'].visible = false;
			items['wave_3'].visible = false;

		}

		protected function orderLayers():void {
			var z:Number = 0;
			var p:DisplayObject;
			for each(var val:String in items_ordered) {
				var d:DisplayObject = items[val];
				if (p === null) {
					p = d.parent;
				}
				
				if (d.parent.getChildIndex(d) != z) {
					d.parent.setChildIndex(d, z);
				}
				
				d.z = z;
				z++;
			}
			display_txt.parent.setChildIndex(display_txt, z);
		}
		
		protected function process(e:Event):void {
			if (elapsedTimeFast.currentCount > 5) {
				items['cloud_1'].x -= 7;
				items['cloud_2'].x -= 5;
				elapsedTimeFast.reset();
				elapsedTimeFast.start();
				
				if (items['cloud_1'].x < -items['cloud_1'].width) {
					items['cloud_1'].x += 1500;
				}
				if (items['cloud_2'].x < -items['cloud_2'].width) {
					items['cloud_2'].x += 1500;
				}
			}			
			if (elapsedTime.currentCount > 10) {
				if (items['wave_1'].visible) {
					items['wave_1'].visible = false;
					items['wave_2'].visible = true;
				} else if (items['wave_2'].visible) {
					items['wave_2'].visible = false;
					items['wave_3'].visible = true;
				} else if (items['wave_3'].visible) {
					items['wave_3'].visible = false;
					items['wave_1'].visible = true;
				}
				elapsedTime.reset();
				elapsedTime.start();
			}
		}
	}
}
