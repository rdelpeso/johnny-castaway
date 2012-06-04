package com.islanddragon.johnny {
	public class Action {
		public var actionName:String = "";
		public var assetName:String = "";
		public var params:Object = new Object();
		public var delay:int = 0;

		public function Action(an:String, asn:String, p:Object, d:int):void {
			actionName = an;
			assetName = asn;
			params = p;
			delay = d;
		}
	}
}
