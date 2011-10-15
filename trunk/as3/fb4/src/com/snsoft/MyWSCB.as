package com.snsoft {
	import com.snsoft.ws.IWS;
	import com.snsoft.ws.IWSCB;
	import com.snsoft.ws.WSStatus;

	public class MyWSCB implements IWSCB {
		public function MyWSCB() {
		}

		public function callBack(stauts:String, data:Object = null):void {
			trace("MyWSCB", stauts, data);
		}

	}
}
