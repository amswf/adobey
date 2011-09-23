package com.snsoft.util.ws {

	public class ConnClient {

		private var callBack:Function;

		public function ConnClient(callBack:Function) {
			this.callBack = callBack;
		}

		public function initCompleteCallBack():void {
			callBack.apply(null);
		}
	}
}
