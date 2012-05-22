package com.islanddragon.johnny {
	import com.bensilvis.spriteSheet.SpriteSheet;
	import com.mikechambers.as3corelib.JSON;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;

	public class Director extends Sprite{
		[Embed(source = '../../../../lib/original.skin', mimeType = 'application/octet-stream')]
		protected var Skin:Class;
		protected var s:Stage;
		protected var skinData:ByteArray = new Skin() as ByteArray;
		protected var t:Timer;
		protected var actors:Dictionary = new Dictionary();
		protected var props:Dictionary = new Dictionary();
		protected var scripts:Dictionary = new Dictionary();
		protected var depth:int = 0;
		protected var expectedDepth:int = 0;
		protected var cyclesUpdate:int = 5;
		protected var cycleLength:int = 20;
		protected var assetsLoaded:Boolean = false;
		
		public function Director (s:Stage) {
			t = new Timer(cycleLength);
			this.s = s;
		}
		
		public function run():void {
			t.start();
			addEventListener(Event.ENTER_FRAME, throller);
		}
		
		public function throller(e:Event):void {
			var elapsedTime:int = t.currentCount * cycleLength;
			if (t.currentCount < cyclesUpdate || assetsLoaded === false) {
				return;
			}
			trace('triggered ' + stage.height);
			t.reset();
			t.start();
			update(e);
		}
		
		public function update(e:Event):void {
			draw();
		}
		
		public function draw():void {
			for (var i:String in actors) {
				actors[i].draw();
			}
		}
		
		public function addActor(k:String, v:Actor):void {
			if (actors.hasOwnProperty(k) === false) {
				actors[k] = v;
				s.addChild(v);
				depth++;
			}
		}

		public function addProp(k:String, v:Prop):void {
			if (props.hasOwnProperty(k) === false) {
				props[k] = v;
				s.addChild(v);
				depth++;
			}
		}

		public function addScript(k:String, v:Script):void {
			if (scripts.hasOwnProperty(k) === false) {
				scripts[k] = v;
			}
		}
		
		public function loadAssets():void {
			loadSkin();
		}

		protected function loadSkin(name:String = 'original'):void {
			var z:Zip = new Zip();
			z.loadBytes(skinData);

			expectedDepth = z.getFileCount();
			addEventListener(Event.ENTER_FRAME, checkLoaded);
			
			for (var i:Number = 0; i < z.getFileCount(); i++) {
				var ldr:CustomLoader = new CustomLoader();
				var zf:ZipFile = z.getFileAt(i);
				var key:String = zf.filename.replace('.png', '');
				
				var fname:Array = zf.filename.substr(0, zf.filename.indexOf('.png')).split('__');
				ldr.fileName = fname;
				ldr.director = this;
				
				if (fname[0] === 'spritesheet') {
					ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoadActor);
					ldr.loadBytes(zf.content);
					continue;
				}
	
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoadProp);
				ldr.loadBytes(zf.content);
			}
		}

		protected function checkLoaded(e:Event):void {
			if (e.target.depth >= e.target.expectedDepth) {
				e.target.assetsLoaded = true;
				e.target.removeEventListener(Event.ENTER_FRAME, e.target.checkLoaded);
				e.target.addEventListener(Event.ENTER_FRAME, e.target.throller);
				run();
			}
		}
		
		protected function completedLoadActor(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			var b:Bitmap = new Bitmap(e.target.content.bitmapData);
			e.target.loader.director.addActor(l.fileName[3], new Actor(l.fileName[3], b, l.fileName[1], l.fileName[2]));
			depth++;
		}

		protected function completedLoadProp(e:Event):void {
			depth++;
		}

		protected function completedLoadScript(e:Event):void {
			
		}
	
		protected function loadSpriteSheet(e:Event):void {
			var b:Bitmap = new Bitmap(e.target.content.bitmapData);
			//ss = new SpriteSheet(b, 75, 75);
			//globalTimer.reset();
			//globalTimer.start();
			//johnnyPlaceHolder = new Bitmap();
			//johnny = new Johnny(this, johnnyPlaceHolder, globalTimer, ss);
			//addEventListener(Event.ENTER_FRAME, johnny.update);
		}
		
		
		
		
		
		
		
		
		
	}
}
