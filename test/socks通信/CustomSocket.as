package {
	import flash.display.Sprite;
	import flash.errors.*;
	import flash.events.*;
	import flash.net.Socket;
	import fl.controls.TextArea;
	import flash.text.TextField;

	public class CustomSocket extends Socket {
		
		private var response:String = null;
		private var ta:TextArea = null;
		
		public function CustomSocket(ta:TextArea,host:String = null, port:uint = 0) {
			super(host, port);
			configureListeners();
			this.ta = ta;
		}

		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}

		public function writeln(str:String):void {
			str += "\n";
			try {
				writeUTFBytes(str);
			} catch (e:IOError) {
				trace(e);
			}
		}
		
		public function getResponse():String{
			return this.response;
		}
		
		public function isResponse():Boolean{
			if (this.response != null){
				return true;
			}
			return false;
		}

		private function sendRequest():void {
			trace("sendRequest");
			response = "";
			//writeln("GET /");
			flush();
		}

		private function readResponse():void {
			var str:String = readUTFBytes(bytesAvailable);
			response = str;
			this.ta.appendText(str);
			trace(this.ta.maxVerticalScrollPosition);
			trace(this.ta.textHeight);
			trace(this.ta.height);
			this.ta.verticalScrollPosition = this.ta.maxVerticalScrollPosition /2 - 7;
			
			//this.ta.scrollV = this.ta.maxScrollV - 13;
		}

		private function closeHandler(event:Event):void {
			//trace("closeHandler: " + event);
			//trace(response.toString());
		}

		private function connectHandler(event:Event):void {
			//trace("connectHandler: " + event);
			//sendRequest();
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			//trace("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			//trace("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			//trace("socketDataHandler: " + event);
			readResponse();
		}
	}
}