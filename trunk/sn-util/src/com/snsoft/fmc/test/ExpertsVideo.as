package com.snsoft.fmc.test{
	import com.snsoft.fmc.NSICode;
	import com.snsoft.util.ComboBoxUtil;
	import com.snsoft.xmldom.XMLFastConfig;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
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
		}
		
		private function handlerRefreshBtnClick(e:Event):void{
			updateSeatSO();
		}
		
		private function handlerRoomComboBoxChange(e:Event):void{
			var box:ComboBox = e.currentTarget as ComboBox;
			var clientId:String = String(box.value);
			var rspd:Responder = new Responder(reqVideoResult,reqVideoStatus);
			nc.call("reqVideo",rspd,clientId);
		}
		
		/**
		 * 共享对象Responder事件  
		 * @param obj
		 * 
		 */		
		private function reqVideoResult(obj:Object):void{
			trace("reqVideoResult");
		}
		
		/**
		 * 共享对象Responder事件 
		 * @param obj
		 * 
		 */		
		private function reqVideoStatus(obj:Object):void{
			trace("reqVideoStatus");
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
				seatSO.initSO();
				seatSO.addEventListener(SyncEvent.SYNC,handlerSync);
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
			var rspd:Responder = new Responder(localNcCallSeatListResult,localNcCallSeatListStatus);
			nc.call("vcService.getSeatList",rspd,this.userType);
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
				for(var i:int = 0;i<array.length;i++){
					var obj:Object = array[i];
					var userName:String = obj.userName as String;
					var clientId:String = obj.clientId as String;
					var item:Object = ComboBoxUtil.creatCBIterm(userName,clientId);
					roomComBox.addItem(item);
				}
			}
		}
		
		/**
		 * 共享对象Responder事件 
		 * @param obj
		 * 
		 */		
		private function localNcCallSeatListStatus(obj:Object):void{
			trace("localNcCallSeatListStatus");
		}
		
		
		/**
		 * 视频交互，服务端回调到这个客户端 
		 * @param oppositeClientId
		 * @return 
		 * 
		 */		
		public function callBackVideoRequest(oppositeClientId:String):void{
			setMsg("callBackVideoRequest:clientId" + oppositeClientId);
			trace("callBackVideoRequest:clientId",oppositeClientId);
		}
		
		/**
		 * 更新seatSO 
		 * 
		 */		
		private function updateSeatSO():void{
			if(seatSO != null){
				seatSO.updatSO();
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