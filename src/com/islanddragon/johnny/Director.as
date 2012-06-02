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
		protected var cyclesUpdate:int = 6;
		protected var cycleLength:int = 20;
		protected var assetsLoaded:Boolean = false;
		protected var actions:Array = new Array();
		protected var movingActors:Array = [
			'johnny',
			'cloud_1',
			'cloud_2',
			'wave',
		];
		
		public function Director (s:Stage) {
			t = new Timer(cycleLength);
			this.s = s;
			s.scaleMode = "noScale";
			s.align = "CC";
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
			t.reset();
			t.start();
			update(e);
		}
		
		public function update(e:Event):void {
			for (var i:String in scripts) {
				var acts:Array = scripts[i].update();
				if (acts.length > 0) {
					actions.push(acts[0]);
				}
			}
			handleActions();
			draw();
		}
		
		public function draw():void {
			for (var i:String in actors) {
				actors[i].draw();
			}
			for (var j:String in props) {
				props[j].draw();
			}
		}
		
		protected function handleActions():void {
			for (var i:String in actions) {
				var action:Action = actions[i];
				
				if (actors.hasOwnProperty(action.assetName) === true && actors[action.assetName].isBusy() === false) {
					actors[action.assetName].trigger(action.actionName, action.params, action.delay);
					trace('Fired: actors[' + action.assetName + '].trigger(' + action.actionName + ', ' + action.params.toString() + ', ' + action.delay + ')');
					actions.shift();
				}
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
				
				if (fname[0] === 'spritesheet' || movingActors.indexOf(fname[0]) !== -1) {
					ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoadActor);
					ldr.loadBytes(zf.content);
					continue;
				}
	
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completedLoadProp);
				ldr.loadBytes(zf.content);
			}
		}

		protected function loadScripts():void {
			var json:String = (<![CDATA[
				[[
				{"assetName": "sky", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "sea", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "wave_1", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "wave_2", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "wave_3", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "island", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "palm_shadow", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "palm_back", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "palm_tree", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "palm_coco", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "johnny", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "palm_front", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "cloud_1", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{"assetName": "cloud_2", "actionName": "moveToFront", "params": {}, "delay": 0 },
				{
					"assetName": "johnny",
					"actionName": "teleport",
					"params": { "x": 270, "y": 275 },
					"delay": 0
				},
				{
					"assetName": "cloud_1",
					"actionName": "walk",
					"params": { "x": -200, "y": 100 },
					"delay": 0
				},	
				{
					"assetName": "johnny",
					"actionName": "walk",
					"params": { "x": 248, "y": 265 },
					"delay": 0
				},
				{"assetName": "johnny", "actionName": "moveBack", "params": {"times": 2}, "delay": 0 },
				{
					"assetName": "johnny",
					"actionName": "walk",
					"params": { "x": 340, "y": 245 },
					"delay": 0
				},
				{
					"assetName": "johnny",
					"actionName": "walk",
					"params": { "x": 360, "y": 240 },
					"delay": 0
				},
				{
					"assetName": "johnny",
					"actionName": "walk",
					"params": { "x": 400, "y": 245 },
					"delay": 0
				},
				{"assetName": "johnny", "actionName": "moveForward", "params": {"times": 2}, "delay": 0 },
				{
					"assetName": "johnny",
					"actionName": "walk",
					"params": { "x": 442, "y": 261 },
					"delay": 0
				},
				{
					"assetName": "johnny",
					"actionName": "walk",
					"params": { "x": 360, "y": 271 },
					"delay": 0
				}
				]]
			]]>).toString();
			addScript("main", new Script("main", json));
		}
		
		protected function checkLoaded(e:Event):void {
			if (e.target.depth >= e.target.expectedDepth) {
				e.target.assetsLoaded = true;
				e.target.removeEventListener(Event.ENTER_FRAME, e.target.checkLoaded);
				e.target.addEventListener(Event.ENTER_FRAME, e.target.throller);
				e.target.loadScripts();
				run();
			}
		}
		
		protected function completedLoadActor(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			if (l.fileName.length === 1) {
				l.director.addActor(l.fileName[0], new Actor(l.fileName[0], loadBm(e)));
			} else {
				l.director.addActor(l.fileName[3], new Actor(l.fileName[3], loadBm(e), l.fileName[1], l.fileName[2]));
			}
			depth++;
		}

		protected function completedLoadProp(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			l.director.addProp(l.fileName[0], new Prop(l.fileName[0], loadBm(e)));
			depth++;
		}

		protected function completedLoadScript(e:Event):void {
			
		}
	
		protected function loadBm(e:Event):Bitmap {
			return new Bitmap(e.target.content.bitmapData);
		}
	}
}
