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
		 * 配置中的名称 
		 */		
		private static const CFG_USERNAME:String = "userName";
			
		/**
		 * 配置中的名称 
		 */		
		private static const CFG_USERTYPE:String = "userType";
		
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
			var userType:String = XMLFastConfig.getConfig(CFG_USERTYPE);
			
			if(userType == "one" || userType == "two"){
				this.userType = userType;
				initFace();
			}
			else {
				setType();
			}
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
			if(expertsBtn != null){
				this.removeChild(expertsBtn);
			}
			if(tspBtn != null){
				this.removeChild(tspBtn);
			}
			
			var userName:String = XMLFastConfig.getConfig(CFG_USERNAME);
			//用户名
			userNameTfd = new TextField();
			userNameTfd.type = TextFieldType.INPUT;
			userNameTfd.border = true;
			userNameTfd.text = userName;
			userNameTfd.x = 20;
			userNameTfd.y = 340;
			userNameTfd.height = 20;
			userNameTfd.width = 150;
			userNameTfd.visible = false;
			this.addChild(userNameTfd);
			
			//链接按钮
			connBtn = new Button();
			connBtn.label = "链接";
			connBtn.x = 200;
			connBtn.y = 340;
			connBtn.width = 50;
			connBtn.visible = false;
			connBtn.addEventListener(MouseEvent.CLICK,handlerConnBtnClick);
			this.addChild(connBtn);
			
			//专家列表
			roomComBox = new ComboBox();
			roomComBox.x = 300;
			roomComBox.y = 340;
			
			var userType:String = XMLFastConfig.getConfig(CFG_USERTYPE);
			if(userType == "one"){
				roomComBox.visible =false;
			}
			if(userType == "two"){
				
			}
			else {
				roomComBox.visible = true;
			}
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
			
			localVideo = new Video(200,150);
			localVideo.x = 400 ;
			localVideo.y = 0;
			localVideo.visible = false;
			addChild(localVideo);
			
			connectService();
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
		 * 事件	链接按钮按下后初始化网络链接 
		 * @param e
		 * 
		 */		
		private function handlerConnBtnClick(e:Event):void{
			connectService();
		}
		
		private function connectService():void{
			if(nc != null && nc.connected){
				nc.close();
				setMsg("断开链接");
				setConnBtn("链接");
				roomComBox.removeAll();
				updateSeatSO();
				accessBtn.visible = false;
				oppositeVideo.visible = false;
				localVideo.visible = false;
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
				}
				
				seatSO = new SeatSO(VC_SO_NAME,nc);
				seatSO.addEventListener(SyncEvent.SYNC,handlerSync);
				seatSO.initSO();
				updateSeatSO();
				var ncc:NCCall = new NCCall(nc,"vcService.getSeatList",tspSeatListResult,null,this.userType);
				ncc.call();
			}
			else {
				setMsg("e.info.code:" + e.info.code);
			}
		}
		
		/**
		 *  
		 * @param obj
		 * 
		 */		
		private function tspSeatListResult(obj:Object):void{	
			setMsg("tspSeatListResult");
			var array:Array = obj as Array;
			if(array != null){
				for(var i:int = 0;i<array.length;i++){
					var obj:Object = array[i];
					var seat:Seat = DependencyInjection.diObjByClass(obj,Seat) as Seat;
					if(videoName == seat.videoName){
						this.localSeat = DependencyInjection.diObjByClass(seat,Seat) as Seat;
					}
					 
				}
			}
		}
		
		/**
		 * 共享对象事件 
		 * @param e
		 * 
		 */		
		private function handlerSync(e:Event):void{
			setMsg("handlerSync");
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
					trace(seat.clientId,seat.userName,seat.videoName,seat.userType);
				}
			}
		}
		
		/**
		 * 选择用户
		 * @param e
		 * 
		 */		
		private function handlerRoomComboBoxChange(e:Event):void{
			trace("handlerRoomComboBoxChange");
			
			localVideo.attachCamera(camera);
			localVideo.visible = true;
			
			var box:ComboBox = e.currentTarget as ComboBox;
			var oppositeClientId:String = String(box.value);
			var oppositeSeat:Seat = seatHV.findByName(oppositeClientId) as Seat;
			callServerReqVideo(this.localSeat.userType,this.localSeat.clientId,oppositeSeat.userType,oppositeClientId);
		}
		
		/**
		 * 请求视频 
		 * @param clientId
		 * @param oppositeClientType
		 * @param oppositeClientId
		 * 
		 */			
		private function callServerReqVideo(userType:String,clientId:String,oppositeClientType:String,oppositeClientId:String):void{
			var ncc:NCCall = new NCCall(nc,"callBackReqVideo",null,null,userType,clientId,oppositeClientType,oppositeClientId);
			ncc.call();
		}	
		
		/**
		 * 被请求视频
		 * @param oppositeClientId
		 * @return 
		 * 
		 */		
		public function callBackVideoRequest(oppositeUserType:String, oppositeClientId:String,oppositeVideoName:String):void{
			setMsg("oppositeClientId:" + oppositeClientId+"视频请求，请点击接受。");
			accessBtn.visible = true;
			this.oppositeSeat.clientId = oppositeClientId;
			this.oppositeSeat.userType = oppositeUserType;
			this.oppositeSeat.videoName = oppositeVideoName;
			
			//下面是，用户按下按钮
		}
		
		/**
		 * 事件：接受按钮按下, 接受请求 
		 * @param e
		 * 
		 */		
		private function handlerAccessBtnClick(e:Event):void{
			localVideo.attachCamera(camera);
			localVideo.visible = true;
			accessBtn.visible = false;
			//发布视频
			accessCamera();
			//通知请求方，已接受视频 
			callServiceAccessVideo();
		}
		
		/**
		 * 通知请求方，已接受视频
		 * 
		 */		
		private function callServiceAccessVideo():void{
			var ncc:NCCall = new NCCall(nc,"callBackAccessVideo",null,null,this.oppositeSeat.clientId,this.localSeat.clientId, this.localSeat.videoName);
			ncc.call();
		}
		
		/**
		 * 请求方接到通知，已接受视频 
		 * @param clientVideoName
		 * 
		 */		
		public function callBackReqAccessVideo(clientId:String,clientVideoName:String):void{
			trace("clientVideoName:",clientVideoName,"localSeat.videoName",localSeat.videoName);
			var seat:Seat = this.seatHV.findByName(clientId) as Seat;
			this.oppositeSeat.clientId = seat.clientId;
			this.oppositeSeat.userType = seat.userType;
			playOppositeVideo(clientVideoName);
			if(clientVideoName != localSeat.videoName){
				accessCamera();
				callServicePassiveClientPlayVideo();
			}
			
		}	
		
		/**
		 * 通知被请求方,播放视频
		 * 
		 */		
		public function callServicePassiveClientPlayVideo():void{
			setMsg(" callServicePassiveClientPlayVideo "+" oppositeSeat.clientId "+oppositeSeat.clientId);
			var ncc:NCCall = new NCCall(nc,"callBackPassiveClientPlayVideo",null,null,oppositeSeat.userType,oppositeSeat.clientId);
			ncc.call();
		}
		
		/**
		 * 被请求方，播放视频
		 * 
		 */		
		public function callBackPassiveClientPlayVideo(clientId:String):void{
			setMsg("callBackPassiveClientPlayVideo：clientId　"+ clientId);
			playOppositeVideo(oppositeSeat.videoName);
		}
		
		/**
		 * 播放对方视频 
		 * @param videoName
		 * 
		 */		
		public function playOppositeVideo(videoName:String):void{
			setMsg("playOppositeVideo:videoName"+ videoName);
			if(nsOpposite != null){
				nsOpposite.close();
			}
			nsOpposite = new NetStream(nc,NetStream.CONNECT_TO_FMS);
			nsOpposite.bufferTime = 0.1;
			nsOpposite.play(videoName);
			oppositeVideo.attachNetStream(nsOpposite);
			oppositeVideo.visible = true;
		}
		
		/**
		 * 发布视频 
		 * 
		 */		
		public function accessCamera():void{
			
			if(camera != null && mic != null){
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
			trace(msg);
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