package com.snsoft.fmc.test{
	import com.snsoft.fmc.NSICode;
	import com.snsoft.fmc.NSPublishType;
	import com.snsoft.fmc.test.vi.Seat;
	import com.snsoft.util.ComboBoxUtil;
	import com.snsoft.util.xmldom.XMLFastConfig;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamInfo;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class OnVideo extends Sprite{
		
		private var rtmp:String = null;
		
		private static const VC_SO_NAME:String = "vc_so_name";
				
		private var localNc:NetConnection;
		
		private var netNc:NetConnection;
		
		private var liveNs:NetStream;
		
		private var recordNs:NetStream;
		
		private var netNs:NetStream;
		
		private var mic:Microphone;
		
		private var camera:Camera;
		
		private var localVideo:Video;
		
		private var netVideo:Video;
		
		private var liveVideoName:String = "lala_live";
		
		private var recordVideoName:String = "lala_record";
		
		private var hallComBox:ComboBox;
		
		private var roomComBox:ComboBox;
		
		private var roomName:String;
		
		private var seatSO:SeatSO;
		
		//private var rtmpUrlTfd:TextField;
		
		private var userNameTfd:TextField;
		
		private var connBtn:Button;
		
		private var disConnBtn:Button;
		
		private var videoName:String;
		
		private var isConn:Boolean = false;
		
		public function OnVideo()
		{
			super();
			loadConfig();
			
		}
		
		public function loadConfig():void{
			XMLFastConfig.instance("config.xml",handlerXMLFastConfigComplete);
		}
		
		public function handlerXMLFastConfigComplete(e:Event):void{
			initComBox();
		}
		
		public function initComBox():void{
			rtmp = XMLFastConfig.getConfig("url");
			
			userNameTfd = new TextField();
			userNameTfd.type = TextFieldType.INPUT;
			userNameTfd.border = true;
			userNameTfd.text = "defName";
			userNameTfd.x = 20;
			userNameTfd.y = 340;
			userNameTfd.height = 20;
			userNameTfd.width = 150;
			this.addChild(userNameTfd);
			
			connBtn = new Button();
			connBtn.label = "链接";
			connBtn.x = 200;
			connBtn.y = 340;
			connBtn.width = 50;
			connBtn.addEventListener(MouseEvent.CLICK,handlerConnBtnClick);
			this.addChild(connBtn);
			
			disConnBtn = new Button();
			disConnBtn.label = "断开";
			disConnBtn.x = 250;
			disConnBtn.y = 340;
			disConnBtn.width = 50;
			disConnBtn.addEventListener(MouseEvent.CLICK,handlerDisConnBtnClick);
			this.addChild(disConnBtn);
			
			hallComBox = new ComboBox();
			hallComBox.x = 300;
			hallComBox.y = 340;
			this.addChild(hallComBox);
			hallComBox.addEventListener(Event.CHANGE,handlerHallComboBoxChange);
			
			roomComBox = new ComboBox();
			roomComBox.x = 400;
			roomComBox.y = 340;
			this.addChild(roomComBox);
			roomComBox.addEventListener(Event.CHANGE,handlerRoomComboBoxChange);
			
		}
		
		private function handlerConnBtnClick(e:Event):void{
			if(!isConn){
				init();
			}
		}
		
		private function handlerDisConnBtnClick(e:Event):void{
			if(isConn){
				localNc.close();
				this.removeChild(localVideo);
				roomComBox.removeAll();
				hallComBox.removeAll();
				userNameTfd.type = TextFieldType.INPUT;
			}
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void{
			localNc = new NetConnection();
			mic = Microphone.getMicrophone();
			camera = Camera.getCamera();
			
			if(camera != null && mic != null){
				trace(camera.fps);
				camera.setKeyFrameInterval(15);
				camera.setMode(400,300,15,false);
				camera.setQuality(80000,0);
				camera.addEventListener(ActivityEvent.ACTIVITY,handlerCameraActivityEvent);
				
				mic.setLoopBack(false);
				mic.setUseEchoSuppression(true);
				
				localVideo = new Video(200,150);
				localVideo.x = 400 ;
				localVideo.y = 0;
				localVideo.attachCamera(camera);
				addChild(localVideo);
				
				localNc.client = this;
				localNc.objectEncoding = ObjectEncoding.AMF3;
				trace(rtmp);
				localNc.connect(rtmp,this.getUserNameTfdText());
				localNc.addEventListener(NetStatusEvent.NET_STATUS,handlerLocalNCStatus);
				localNc.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
			}
			else {
				trace("缺少摄像头或声音设备！");
			}
			
		}
		
		/**
		 * nc 链接成功 
		 * @param e
		 * 
		 */		
		private function handlerLocalNCStatus(e:NetStatusEvent):void {
			
			userNameTfd.type = TextFieldType.DYNAMIC;
			//调用red5的Service
			trace("handlerLocalNCStatus:",e.info.code);
			if(e.info.code == NSICode.NetConnection_Connect_Success){
				seatSO = new SeatSO(VC_SO_NAME,localNc);
				seatSO.initSO();
				seatSO.addEventListener(SyncEvent.SYNC,handlerSync);	
				var rspd:Responder = new Responder(localNcCallRoomListResult,localNcCallRoomListStatus);
				localNc.call("vcService.getRoomList",rspd);
			}
		}
		
		private function localNcCallRoomListResult(obj:Object):void{
			var array:Array = obj as Array;
			hallComBox.removeAll();
			if(array != null){
				hallComBox.addItem(ComboBoxUtil.creatCBIterm("请选择聊天室",null));
				for(var i:int = 0;i<array.length;i++){
					var obj:Object = array[i];
					var roomName:String = obj.roomName as String;
					var item:Object = ComboBoxUtil.creatCBIterm(roomName,roomName);
					hallComBox.addItem(item);
				}
			}
		}
		
		private function handlerHallComboBoxChange(e:Event):void{
			var box:ComboBox = e.currentTarget as ComboBox;
			var roomName:String = String(box.value);
			if(roomName != null){
				
				if(this.roomName == null){
					var rspdc:Responder = new Responder(localNcCallCreaSeatResult,localNcCallCreaSeatStatus);
					localNc.call("vcService.creatSeat",rspdc,roomName,getUserNameTfdText());
				}
				else {
					var rspdm:Responder = new Responder(localNcCallMoveSeatResult,localNcCallMoveSeatStatus);
					localNc.call("vcService.moveSeat",rspdm,getUserNameTfdText(),this.roomName,roomName);
				}
				this.roomName = roomName;
			}
		}
		
		private function getUserNameTfdText():String{
			return userNameTfd.text;
		}
		
		private function handlerRoomComboBoxChange(e:Event):void{
			var box:ComboBox = e.currentTarget as ComboBox;
			var videoName:String = String(box.value);
			if(roomName != null){
				this.videoName = videoName;
				initNetVideo();
			}
		}
		
		private function localNcCallMoveSeatResult(obj:Object):void{
			seatSO.updateSO();
		}
		
		private function localNcCallCreaSeatResult(obj:Object):void{
			var userName:String = obj.userName;
			var videoName:String = obj.videoName;	
			
			liveNs = new NetStream(localNc,NetStream.CONNECT_TO_FMS);
			liveNs.bufferTime = 0.1;
			liveNs.attachCamera(camera);
			liveNs.attachAudio(mic);
			liveNs.publish(videoName,NSPublishType.LIVE);
			
			//recordNs = new NetStream(localNc,NetStream.CONNECT_TO_FMS);
			//recordNs.bufferTime = 0.1;
			//recordNs.attachCamera(camera);
			//recordNs.attachAudio(mic);
			//recordNs.publish(videoName+"_rcd",NSPublishType.RECORD);
			seatSO.updateSO();
		}
		
		private function localNcCallSeatListResult(obj:Object):void{
			trace("localNcCallSeatListResult");
			var array:Array = obj as Array;
			if(array != null){
				roomComBox.removeAll();
				roomComBox.addItem(ComboBoxUtil.creatCBIterm("请选择网友",null));
				for(var i:int = 0;i<array.length;i++){
					var obj:Object = array[i];
					var userName:String = obj.userName as String;
					var videoName:String = obj.videoName as String;
					var item:Object = ComboBoxUtil.creatCBIterm(userName,videoName);
					roomComBox.addItem(item);
				}
			}
		}
		
		private function localNcCallMoveSeatStatus(obj:Object):void{
			trace("localNcCallSeatListStatus");
		}
		
		private function localNcCallCreaSeatStatus(obj:Object):void{
			trace("localNcCallSeatListStatus");
		}
		
		private function localNcCallSeatListStatus(obj:Object):void{
			trace("localNcCallSeatListStatus");
		}
		
		private function localNcCallRoomListStatus(obj:Object):void{
			trace("localNcCallRoomListStatus");
		}
		
		private function initNetVideo():void{
			netNc = new NetConnection();
			netNc.client = this;
			netNc.objectEncoding = ObjectEncoding.AMF3;
			
			trace(rtmp);
			netNc.connect(rtmp);
			netNc.addEventListener(NetStatusEvent.NET_STATUS,handlerNetNCStatus);
			netNc.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError); 
		}
		
		private function handlerNetNCStatus(e:NetStatusEvent):void {
			trace("handlerNetNCStatus:",e.info.code);
			if(e.info.code == NSICode.NetConnection_Connect_Success){
				netNs = new NetStream(netNc,NetStream.CONNECT_TO_FMS);
				netNs.bufferTime = 0.1;
				netVideo = new Video(360,270);
				this.addChild(netVideo);
				netNs.play(videoName);
				trace(videoName);
				netVideo.attachNetStream(netNs);
			}
		}
		
		
		private function handlerSync(e:Event):void{
			if(roomName != null){
				var rspd:Responder = new Responder(localNcCallSeatListResult,localNcCallSeatListStatus);
				localNc.call("vcService.getSeatList",rspd,roomName);
			}
		}
		
		/**
		 * camera 摄像头激活 
		 * @param event
		 * 
		 */		
		private function handlerCameraActivityEvent(event:ActivityEvent):void {
			//trace("activityHandler: " + event);
		}
		
		/**
		 * nc 链接失败
		 * @param e
		 * 
		 */	
		private function handlerIOError(e:IOErrorEvent):void {
			trace("handlerIOError");
		}
		
		public function onBWDone():void{
			trace("onBWDone");
		}  
		
	}
}