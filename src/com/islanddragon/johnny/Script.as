package com.islanddragon.johnny {
	import com.mikechambers.as3corelib.*;
	public class Script {
		protected var _name:String;
		protected var s:String;
		protected var sParsed:Object;
		protected var indexes:Array;

		public function Script(name:String, s:String) {
			this._name = name;
			this.s = s;
			indexes = new Array();
			parseScript();
		}

		protected function parseScript():void {
			sParsed = JSON.decode(s);
		}

		public function update():Array {
			var actions:Array = new Array();
			for (var i:String in sParsed) {
				for (var j:String in sParsed[i]) {
					var o:Object = sParsed[i][j];
					var a:Action = new Action(o.actionName, o.assetName, o.params, o.delay);
					actions.push(a);
				}
			}
			return actions;
		}
	}
}
