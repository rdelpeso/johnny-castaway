package com.islanddragon.johnny {
	import com.mikechambers.as3corelib.*;
	public class Script {
		protected var _name:String;
		protected var s:String;
		protected var sParsed:Object;
		protected var actions:Array;
		protected var indexes:Array;

		public function Script(name:String, s:String) {
			this._name = name;
			this.s = s;
			actions = new Array();
			indexes = new Array();
			parseScript();
		}

		protected function parseScript():void {
			sParsed = JSON.decode(s);
		}

		public function update():Array {
			var actions:Array = new Array();
			for (var i:String in sParsed) {
				if (indexes.hasOwnProperty(i) === false) {
					indexes[i] = 0;
				}
				
				if (sParsed[i].hasOwnProperty(indexes[i])) {
					var o:Object = sParsed[i][indexes[i]];
					var a:Action = new Action(o.actionName, o.assetName, o.params, o.delay);
					actions.push(a);
					indexes[i]++;
				}
			}
			return actions;
		}
	}
}
