package com.islanddragon.johnny {
	import com.mikechambers.as3corelib.*;
	public class Script {
		protected var _name:String;
		protected var s:String;
		protected var sParsed:Object;
		protected var key:int;

		public function Script(name:String, s:String) {
			this._name = name;
			this.s = s;
			parseScript();
		}

		protected function parseScript():void {
			sParsed = JSON.decode(s);
			reset();
		}

		public function getAction(rand:Boolean = false):Action {
			var o:Object;
			if (rand) {
				var k:int = Math.round((Math.random() * (sParsed[0].length - 1)));
				if (sParsed[0][k] !== null) {
					o = sParsed[0][k];
					return new Action(o.actionName, o.assetName, o.params, o.delay);
				}
				return null;
			}
			
			if (key < sParsed[0].length) {
				o = sParsed[0][key];
				return new Action(o.actionName, o.assetName, o.params, o.delay);
			}
			return null;
		}

		public function next():void {
			key++;
		}
		
		public function isDone():Boolean {
			return (key >= sParsed[0].length);
		}
		
		public function reset():void {
			key = 0;
		}
	}
}
