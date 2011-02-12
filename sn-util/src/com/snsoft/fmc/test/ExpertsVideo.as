package com.snsoft.fmc.test{
	import com.snsoft.fmc.NCCall;
	import com.snsoft.fmc.NSICode;
	import com.snsoft.fmc.NSPublishType;
	import com.snsoft.fmc.test.vi.Seat;
	import com.snsoft.util.ComboBoxUtil;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.di.DependencyInjection;
	import com.snsoft.xmldom.XMLFastConfig;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	
	import flash.display.MovieClip;
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
	import flash.net.ObjectEncoding;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	public class ExpertsVideo extends MovieClip{
		
		/**
		 * 配置中的名称 
		 */		
		private static const CFG_URL:String = "url";
		
		/**
		 * 共享对象名称 
		 */		
		private static const VC_SO_NAME:String = "vc_so_name";
		
		/**
		 * rtmp地址 
		 */		
		private var rtmpUrl:String = null;
		
		/**
		 * 用户名文本框 
		 */		
		private var userNameTfd:TextField;
		
		/**
		 * 用户名文本框 
		 */		
		private var msgTfd:TextField;
		
		/**
		 * 链接按钮 
		 */		
		private var connBtn:Button;
		
		/**
		 * 链接按钮 
		 */		
		private var refreshBtn:Button;
		
		/**
		 * 链接按钮 
		 */		
		private var accessBtn:Button;
		
		/**
		 * 请求视频按钮 
		 */		
		private var reqVideoBtn:Button;
		
		/**
		 * 专家列表
		 */		
		private var roomComBox:ComboBox;
		
		/**
		 * 触摸屏类型按钮 
		 */		
		private var tspBtn:Button;
		
		/**
		 * 专家类型按钮 
		 */		
		private var expertsBtn:Button;
		
		/**
		 * 网络链接 
		 */		
		private var nc:NetConnection;
		
		/**
		 * 本地发布的流 
		 */		
		private var nsLocal:NetStream;
		
		/**
		 * 对方发布的流 
		 */		
		private var nsOpposite:NetStream;
		
		/**
		 * 共享对象管理类 
		 */		
		private var seatSO:SeatSO;
		
		/**
		 * 用户名，服务端通过client对象访问
		 */
		private var _userName:String;
		
		/**
		 * 用户ID,也是视频发布名称，服务端通过client对象访问
		 */	
		private var _videoName:String;
		
		/**
		 * 用户类型
		 */
		private var _userType:String = "two";
		
		/**
		 * 客户端在服务端的信息对象 
		 */		
		private var localSeat:Seat = null;
		
		/**
		 * 请求方客户端在服务端的信息对象 
		 */	
		private var oppositeSeat:Seat = new Seat();
		
		/**
		 * 用户列表 
		 */		
		private var seatHV:HashVector = null;
		
		/**
		 * 话筒 
		 */		
		private var mic:Microphone;
		
		/**
		 * 摄像头 
		 */		
		private var camera:Camera;
		
		/**
		 * 本地视频 
		 */		
		private var localVideo:Video;
		
		/**
		 * 对方视频 
		 */		
		private var oppositeVideo:Video;
		
		/**
		 * 构造方法 
		 * 
		 */		
		public function ExpertsVideo()
		{
			super();
			loadConfig();
		}
		
		/**
		 * 加载配置文件 
		 * 
		 */		
		private function loadConfig():void{
			XMLFastConfig.instance("config.xml",handlerXMLFastConfigComplete);
			
		}
		
		/**
		 * 事件  
		 * @param e
		 * 
		 */		
		public function handlerXMLFastConfigComplete(e:Event):void{
			//初始化参数
			rtmpUrl = XMLFastConfig.getConfig(CFG_URL);
			//选择用户端类型
			setType();
		}
		
		/**
		 * 选择用户端类型 
		 * 
		 */		
		public function setType():void{
			
			//触摸屏类型按钮
			tspBtn = new Button();
			tspBtn.label = "触摸屏";
			tspBtn.x = 200;
			tspBtn.y = 340;
			tspBtn.width = 50;
			tspBtn.addEventListener(MouseEvent.CLICK,handlerTspBtnClick);
			this.addChild(tspBtn);
			
			//触摸屏类型按钮
			expertsBtn = new Button();
			expertsBtn.label = "专家";
			expertsBtn.x = 250;
			expertsBtn.y = 340;
			expertsBtn.width = 50;
			expertsBtn.addEventListener(MouseEvent.CLICK,handlerExpertsBtnClick);
			this.addChild(expertsBtn);
		}
		
		/**
		 * 事件	TSP按钮按下  
		 * @param e
		 * 
		 */		
		private function handlerTspBtnClick(e:Event):void{
			this.userType = "two";
			//初始化界面 
			initFace();
			
		}
		
		/**
		 * 事件	专家按钮按下 
		 * @param e
		 * 
		 */		
		private function handlerExpertsBtnClick(e:Event):void{
			this.userType = "one";
			
			//初始化界面 
			initFace();
		}
		
		
		/**
		 * 初始化界面 
		 * 
		 */		
		private function initFace():void{
			//删除类型按钮
			this.removeChild(expertsBtn);
			this.removeChild(tspBtn);
			//用户名
			userNameTfd = new TextField();
			userNameTfd.type = TextFieldType.INPUT;
			userNameTfd.border = true;
			userNameTfd.text = "defName";
			userNameTfd.x = 20;
			userNameTfd.y = 340;
			userNameTfd.height = 20;
			userNameTfd.width = 150;
			this.addChild(userNameTfd);
			
			//链接按钮
			connBtn = new Button();
			connBtn.label = "链接";
			connBtn.x = 200;
			connBtn.y = 340;
			connBtn.width = 50;
			connBtn.addEventListener(MouseEvent.CLICK,handlerConnBtnClick);
			this.addChild(connBtn);
			
			//专家列表
			roomComBox = new ComboBox();
			roomComBox.x = 300;
			roomComBox.y = 340;
			this.addChild(roomComBox);
			roomComBox.addEventListener(Event.CHANGE,handlerRoomComboBoxChange);
			
			//刷新按钮
			refreshBtn = new Button();
			refreshBtn.label = "刷新";
			refreshBtn.x = 400;
			refreshBtn.y = 340;
			refreshBtn.width = 50;
			refreshBtn.addEventListener(MouseEvent.CLICK,handlerRefreshBtnClick);
			this.addChild(refreshBtn);
			
			//接受视频按钮
			accessBtn = new Button();
			accessBtn.label = "接受";
			accessBtn.x = 450;
			accessBtn.y = 340;
			accessBtn.width = 50;
			accessBtn.addEventListener(MouseEvent.CLICK,handlerAccessBtnClick);
			accessBtn.visible = false;
			this.addChild(accessBtn);
			
			//提示信息
			msgTfd = new TextField();
			msgTfd.type = TextFieldType.DYNAMIC;
			msgTfd.border = true;
			msgTfd.text = "";
			msgTfd.x = 20;
			msgTfd.y = 370;
			msgTfd.height = 20;
			msgTfd.width = 400;
			this.addChild(msgTfd);
			
			oppositeVideo = new Video(360,270);
			oppositeVideo.visible = false;
			this.addChild(oppositeVideo);
		}
		
		
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerRefreshBtnClick(e:Event):void{
			updateSeatSO();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerRoomComboBoxChange(e:Event):void{
			var box:ComboBox = e.currentTarget as ComboBox;
			var oppositeClientId:String = String(box.value);
			var oppositeSeat:Seat = seatHV.findByName(oppositeClientId) as Seat;
			trace(oppositeSeat.userName,oppositeSeat.videoName,oppositeSeat.userType);
			callServerReqVideo(this.localSeat.clientId,oppositeSeat.userType,oppositeClientId);
		}
		
		/**
		 *  
		 * @param clientId
		 * @param oppositeClientType
		 * @param oppositeClientId
		 * 
		 */			
		private function callServerReqVideo(clientId:String,oppositeClientType:String,oppositeClientId:String):void{
			var ncc:NCCall = new NCCall(nc,"callBackReqVideo",null,null,clientId,oppositeClientType,oppositeClientId);
			ncc.call();
		}		
		
		/**
		 * 事件	链接按钮按下后初始化网络链接 
		 * @param e
		 * 
		 */		
		private function handlerConnBtnClick(e:Event):void{
			if(nc != null && nc.connected){
				nc.close();
				setMsg("断开链接");
				setConnBtn("链接");
				roomComBox.removeAll();
				updateSeatSO();
				accessBtn.visible = false;
				oppositeVideo.visible = false;
			}
			else {
				setMsg("请稍等...");
				nc = new NetConnection();
				nc.client = this;
				nc.connect(rtmpUrl,getUserName(),getVideoName(),this.userType);
				nc.addEventListener(NetStatusEvent.NET_STATUS,handlerNcStatus);
				nc.addEventListener(IOErrorEvent.IO_ERROR,handlerIOError);
			}
		}
		
		/**
		 * nc 链接成功 
		 * @param e
		 * 
		 */		
		private function handlerNcStatus(e:NetStatusEvent):void {
			
			userNameTfd.type = TextFieldType.DYNAMIC;
			//调用red5的Service
			trace("handlerLocalNCStatus:",e.info.code);
			if(e.info.code == NSICode.NetConnection_Connect_Success){
				setMsg("链接成功");
				setConnBtn("断开");
				seatSO = new SeatSO(VC_SO_NAME,nc);
				seatSO.addEventListener(SyncEvent.SYNC,handlerSync);
				seatSO.initSO();
				updateSeatSO();
			}
			else {
				setMsg("e.info.code:" + e.info.code);
			}
		}
		
		/**
		 * 共享对象事件 
		 * @param e
		 * 
		 */		
		private function handlerSync(e:Event):void{
			setMsg("handlerSync");
			trace("handlerSync");
			var ncc:NCCall = new NCCall(nc,"vcService.getSeatList",localNcCallSeatListResult,null,"one");
			ncc.call();
		}
		
		/**
		 * 共享对象Responder事件  
		 * @param obj
		 * 
		 */		
		private function localNcCallSeatListResult(obj:Object):void{	
			setMsg("localNcCallSeatListResult");
			trace("localNcCallSeatListResult");
			var array:Array = obj as Array;
			if(array != null){
				roomComBox.removeAll();
				roomComBox.addItem(ComboBoxUtil.creatCBIterm("请选择专家",null));
				
				seatHV = new HashVector();
				for(var i:int = 0;i<array.length;i++){
					var obj:Object = array[i];
					var seat:Seat = DependencyInjection.diObjByClass(obj,Seat) as Seat;
					seatHV.push(seat,seat.clientId);
					var item:Object = ComboBoxUtil.creatCBIterm(seat.userName,seat.clientId);
					roomComBox.addItem(item);
					if(videoName == seat.videoName){
						this.localSeat = DependencyInjection.diObjByClass(seat,Seat) as Seat;
					}
					trace(seat.clientId,seat.userName,seat.videoName,seat.userType);
				}
			}
		}
		
		 
		
		/**
		 * 允许视频交互，服务端回调到这个客户端 
		 * @param oppositeClientId
		 * @return 
		 * 
		 */		
		public function callBackVideoRequest(clientId:String, oppositeClientId:String,oppositeVideoName:String):void{
			setMsg("cid:" + clientId + "ocid:" + oppositeClientId+"视频请求，请点击接受。");
			trace("cid:" + clientId + "ocid:" + oppositeClientId);
			
			accessBtn.visible = true;
			this.oppositeSeat.clientId = oppositeClientId;
		}
		
		/**
		 * 接受请求按钮按下
		 * @param e
		 * 
		 */		
		private function handlerAccessBtnClick(e:Event):void{
			accessCamera();
			callServiceAccessVideo();
		}
		
		/**
		 * 做为被请求方同接受视频后，通知请求方播放视频 
		 * @param clientVideoName
		 * 
		 */		
		public function callBackReqAccessVideo(clientVideoName:String):void{
			trace("clientVideoName:",clientVideoName);
			if(nsOpposite != null){
				nsOpposite.close();
			}
			
			nsOpposite = new NetStream(nc,NetStream.CONNECT_TO_FMS);
			nsOpposite.bufferTime = 0.1;
			nsOpposite.play(clientVideoName);
			oppositeVideo.attachNetStream(nsOpposite);
			oppositeVideo.visible = true;
			
			if(clientVideoName != localSeat.videoName){
				accessCamera();
				
			}
		}	
		
		public function callServicePassiveClientPlayVideo():void{
			
		}
		
		/**
		 * 发布视频 
		 * 
		 */		
		public function accessCamera():void{
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
				
				nsLocal = new NetStream(nc,NetStream.CONNECT_TO_FMS);
				nsLocal.bufferTime = 0.1;
				nsLocal.attachCamera(camera);
				nsLocal.attachAudio(mic);
				nsLocal.publish(localSeat.videoName,NSPublishType.LIVE);
			}
			else {
				trace("缺少摄像头或声音设备！");
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
		 * 通知请求方，视频 
		 * 
		 */		
		private function callServiceAccessVideo():void{
			var ncc:NCCall = new NCCall(nc,"callBackAccessVideo",null,null,this.oppositeSeat.clientId, this.localSeat.videoName);
			ncc.call();
		}
		
		/**
		 * 更新seatSO 
		 * 
		 */		
		private function updateSeatSO():void{
			if(seatSO != null){
				seatSO.updateSO();
			}
		}
		
		/**
		 * nc 链接失败
		 * @param e
		 * 
		 */	
		private function handlerIOError(e:IOErrorEvent):void {
			setMsg("handlerIOError");
			trace("handlerIOError");
		}
		
		/**
		 * 获取用户名 
		 * @return 
		 * 
		 */		
		private function getUserName():String{
			this.userName = userNameTfd.text;
			return this.userName;
		}
		
		private function getVideoName():String{
			var name:String = String(new Date().getTime());
			this.videoName = name;
			return this.videoName;
		}
		
		/**
		 * 设置提示信息 
		 * @param msg
		 * 
		 */		
		private function setMsg(msg:String):void{
			msgTfd.text = msg + "    [" + String(int(1000 * Math.random()))+ "]";
		}
		
		/**
		 *  
		 * @param text
		 * 
		 */		
		private function setConnBtn(text:String):void{
			connBtn.label = text;
		}
		
		/**
		 * 客户端回调方法，必须要有 
		 * 
		 */		
		public function onBWDone():void{
			trace("onBWDone");
		}
		
		/**
		 * 用户名 
		 */
		public function get userName():String
		{
			return _userName;
		}
		
		/**
		 * @private
		 */
		public function set userName(value:String):void
		{
			_userName = value;
		}
		
		/**
		 * 用户ID,也是视频发布名称，服务端通过client对象访问
		 */
		public function get videoName():String
		{
			return _videoName;
		}
		
		/**
		 * @private
		 */
		public function set videoName(value:String):void
		{
			_videoName = value;
		}
		
		/**
		 * 用户类型
		 */
		public function get userType():String
		{
			return _userType;
		}
		
		/**
		 * @private
		 */
		public function set userType(value:String):void
		{
			_userType = value;
		}
		
		
	}
}