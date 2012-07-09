package com.islanddragon.johnny {
	import com.bensilvis.spriteSheet.SpriteSheet;
	import com.mikechambers.as3corelib.JSON;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import org.as3commons.zip.Zip;
	import org.as3commons.zip.ZipFile;

	public class Director extends Sprite{
		[Embed(source = '../../../../lib/original.skin', mimeType = 'application/octet-stream')]
		protected var Skin:Class;
		protected var skinData:ByteArray = new Skin() as ByteArray;
		[Embed(source = '../../../../lib/original.actions', mimeType = 'application/octet-stream')]
		protected var Actions:Class;
		protected var actionsData:ByteArray = new Actions() as ByteArray;

		protected var s:Stage;
		protected var t:Timer;
		protected var actors:Dictionary = new Dictionary();
		protected var props:Dictionary = new Dictionary();
		protected var scripts:Dictionary = new Dictionary();
		protected var depth:int = 0;
		protected var expectedDepth:int = 0;
		protected var cyclesUpdate:int = 4;
		protected var cycleLength:int = 20;
		protected var assetsLoaded:Boolean = false;
		protected var queuedScripts:Array = new Array();
		protected var repeatedScripts:Array = new Array();
		
		protected var maskingShape:Shape;
		public var holder:Sprite;

		protected var assetsMap:Object = {
			'Johnny': ['johnny'],
			'Waves': ['waves'],
			'Actor': ['cloud_1','cloud_2','wave']
		};

		public function Director (s:Stage) {
			t = new Timer(cycleLength);
			this.s = s;
			s.scaleMode = "noScale";
			s.align = "CC";
			
			s.addEventListener(Event.RESIZE, function(e:Event):void {
				var s:Stage = e.target as Stage;
				maskingShape.graphics.moveTo(s.stageWidth / 2 - maskingShape.width / 2, s.stageHeight / 2 - maskingShape.height / 2);
			});
			
			holder = new Sprite();

			maskingShape = new Shape()
			maskingShape.graphics.lineStyle();
			maskingShape.graphics.beginFill(0xFFFFFF,1);
			maskingShape.graphics.drawRect(0,0,512,384);
			maskingShape.graphics.endFill();
			
			var mss:Sprite = new Sprite();
			
			holder.mask = maskingShape;
			
			addChild(holder);
			
			this.s.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void {
				trace(e.stageX + ',' + e.stageY);
			} );
		}

		public function run():void {
			t.start();
			addEventListener(Event.ENTER_FRAME, throller);
			runScript({'script':'main'});
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
			handleQueuedScripts();
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
		
		protected function handleQueuedScripts():void {
			for (var i:String in queuedScripts) {
				if (queuedScripts[i].isDone()) {
					if (repeatedScripts.indexOf(int(i)) !== -1) {
						queuedScripts[i].reset();
					} else {
						delete queuedScripts[i];
						continue;
					}
				}
				
				var res:Boolean = handleAction(queuedScripts[i].getAction());
				if (res === true) {
					queuedScripts[i].next();
				}
			}
		}

		public function handleAction(action:Action):Boolean {
			if (action === null) {
				return true;
			}

			if (action.assetName === 'director') {
				handleDirectorAction(action);
				return true;
			}
			
			var target:Prop = null;
			if (actors.hasOwnProperty(action.assetName) === true) {
				target = actors[action.assetName];
			}
			if (props.hasOwnProperty(action.assetName) === true) {
				target = props[action.assetName];
			}

			if (target === null) {
				return true;
			}
			
			if (target.isBusy() === true) {
				return false;
			}
			
			target.trigger(action.actionName, action.params, action.delay);
			return true;
		}
		
		public function handleDirectorAction(a:Action):void {
			this[a.actionName](a.params);
		}
		
		public function runScript(params:Object):void {
			if (scripts.hasOwnProperty(params.script) == false) {
				return;
			}
			
			queuedScripts.push(scripts[params.script]);
			
			if (params.repeat !== true) {
				return;
			}
			
			repeatedScripts.push(queuedScripts.indexOf(scripts[params.script]));
		}

		public function randomActionFromScript(params:Object):void {
			if (scripts.hasOwnProperty(params.script) == false) {
				return;
			}
			handleAction(scripts[params.script].getAction(true));
		}

		public function addActor(k:String, v:Actor):void {
			if (actors.hasOwnProperty(k) === false) {
				actors[k] = v;
				holder.addChild(v);
				depth++;
			}
		}

		public function addProp(k:String, v:Prop):void {
			if (props.hasOwnProperty(k) === false) {
				props[k] = v;
				holder.addChild(v);
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
				
				var method:String = 'completedLoadProp';
				
				for (var cls:String in assetsMap) {
					if (assetsMap[cls].indexOf(fname[0]) !== -1) {
						method = 'completedLoad' + cls;
						break;
					}
				}

				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, this[method]);
				ldr.loadBytes(zf.content);
			}
		}
		
		protected function loadScripts():void {
			var z:Zip = new Zip();
			z.loadBytes(actionsData);

			for (var i:Number = 0; i < z.getFileCount(); i++) {
				var zf:ZipFile = z.getFileAt(i);
				var str:String = zf.content.readUTFBytes(zf.content.length);
				var fname:Array = zf.filename.substr(0, zf.filename.indexOf('.json')).split('__');
				addScript(fname[0], new Script(fname[0], str));
			}
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
		
		protected function completedLoadProp(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			l.director.addProp(l.fileName[0], new Prop(l.director, l.fileName[0], loadBm(e)));
			depth++;
		}

		protected function completedLoadActor(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			if (l.fileName.length === 1) {
				l.director.addActor(l.fileName[0], new Actor(l.director, l.fileName[0], loadBm(e)));
			} else {
				l.director.addActor(l.fileName[3], new Actor(l.director, l.fileName[3], loadBm(e), l.fileName[1], l.fileName[2]));
			}
			depth++;
		}

		protected function completedLoadJohnny(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			l.director.addActor(l.fileName[0], new Johnny(l.director, l.fileName[0], loadBm(e), l.fileName[1], l.fileName[2]));
			depth++;
		}

		protected function completedLoadWaves(e:Event):void {
			var l:CustomLoader = (e.target.loader as CustomLoader);
			l.director.addActor(l.fileName[0], new Waves(l.director, l.fileName[0], loadBm(e), l.fileName[1], l.fileName[2]));
			depth++;
		}
	
		protected function loadBm(e:Event):Bitmap {
			return new Bitmap(e.target.content.bitmapData);
		}
	}
}
