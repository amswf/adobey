package com.snsoft.fmc.test{
	import com.snsoft.fmc.NCCall;
	import com.snsoft.fmc.NSICode;
	import com.snsoft.fmc.NSPublishType;
	import com.snsoft.fmc.test.vi.PlayNetStream;
	import com.snsoft.fmc.test.vi.PubNetStream;
	import com.snsoft.fmc.test.vi.UUNetConnection;
	import com.snsoft.util.ComboBoxUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.UUID;
	import com.snsoft.xmldom.XMLFastConfig;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.Label;
	import fl.controls.TextArea;
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PerformTest extends Sprite{
		
		/**
		 * 话筒 
		 */		
		private var mic:Microphone;
		
		/**
		 * 摄像头 
		 */		
		private var camera:Camera;
		
		/**
		 * 配置中的名称 
		 */		
		private static const CFG_URL:String = "url";
		
		
		private var rtmpUrl:String = "rtmp://192.168.0.33/oflaDemo";
		
		private var ncList:Vector.<UUNetConnection> = new Vector.<UUNetConnection>();
		
		private var nsPlayList:Vector.<PlayNetStream> = new Vector.<PlayNetStream>();
		
		private var nsPubList:Vector.<PubNetStream> = new Vector.<PubNetStream>();
		
		private var videosLayer:Sprite = new Sprite();
		
		private var videoNameList:Vector.<String>;
		
		private var nsPlayOne:PlayNetStream;
		
		private var localVideo:Video;
		
		public function PerformTest()
		{
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			super();
		}
		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
			this.addChild(videosLayer);
			
			creatMicAndVideo();
			
			for(var i:int = 0;i<this.numChildren;i++){
				var uic:UIComponent = this.getChildAt(i) as UIComponent;
				if(uic != null){
					uic.setStyle("textFormat",new TextFormat(null,12));
					if(uic is ComboBox){
						(uic as ComboBox).dropdown.setRendererStyle("textFormat",new TextFormat(null,12));
					}
				}
			}
			
			//链接按钮
			var connectBtn:Button = this.getChildByName("connectBtn") as Button;
			connectBtn.addEventListener(MouseEvent.CLICK,handlerConnectBtnClick);
			//发布按钮
			var publishBtn:Button = this.getChildByName("publishBtn") as Button;
			publishBtn.addEventListener(MouseEvent.CLICK,handlerPublishBtnClick);
			//接收接钮
			var playBtn:Button = this.getChildByName("playBtn") as Button;
			playBtn.addEventListener(MouseEvent.CLICK,handlerPlayBtnClick);
			//刷新按钮
			var refreshBtn:Button = this.getChildByName("refreshBtn") as Button;
			refreshBtn.addEventListener(MouseEvent.CLICK,handlerRefreshBtnClick);
			//视频列表
			var videoListCB:ComboBox = this.getChildByName("videoListCB") as ComboBox;
			videoListCB.addEventListener(Event.CHANGE,handlerVideoListCBChange);
			//设置摄像头按钮
			var cameraBtn:Button = this.getChildByName("cameraBtn") as Button;
			cameraBtn.addEventListener(MouseEvent.CLICK,handlerCameraBtnClick);
			//设置摄像头按钮
			var clearMsgBtn:Button = this.getChildByName("clearMsgBtn") as Button;
			clearMsgBtn.addEventListener(MouseEvent.CLICK,handlerClearMsgBtnClick);
			
			//加载配置
			XMLFastConfig.instance("config.xml",handlerXMLFastConfigComplete);
			
		}
		
		
		/**
		 * 事件  加载配置
		 * @param e
		 * 
		 */		
		public function handlerXMLFastConfigComplete(e:Event):void{
			//初始化参数
			rtmpUrl = XMLFastConfig.getConfig(CFG_URL);
		}
		
		/**
		 * 事件	清除信息 
		 * @param e
		 * 
		 */		
		private function handlerClearMsgBtnClick(e:Event):void{
			var ta:TextArea = this.getChildByName("msgTA") as TextArea;
			ta.text = "";
		}
		
		/**
		 * 设置摄像头
		 * @param e
		 * 
		 */		
		private function handlerCameraBtnClick(e:Event):void{
			setMsg("设置摄像头");
			creatMicAndVideo();
		}
		
		/**
		 * 初始化话筒和摄像头
		 * 
		 */		
		private function creatMicAndVideo():void{
			mic = Microphone.getMicrophone();
			camera = Camera.getCamera();
			
			if(camera != null){
				trace(camera.fps);
				camera.setKeyFrameInterval(15);
				camera.setMode(getCameraWidth(),getCameraHeight(),getFRM(),false);
				camera.setQuality(getCameraQuality()*800,0);
				camera.addEventListener(ActivityEvent.ACTIVITY,handlerCameraActivityEvent);
				
				if(localVideo != null){
					this.removeChild(localVideo);
				}
				localVideo = new Video(200,150);
				localVideo.x = 400 ;
				localVideo.y = 0;
				localVideo.attachCamera(camera);
				this.addChild(localVideo);
			}
			if(mic != null){
				mic.setLoopBack(false);
				mic.setUseEchoSuppression(true);
			}
		}
		
		/**
		 * 链接 
		 * @param e
		 * 
		 */		
		private function handlerConnectBtnClick(e:Event):void{
			videoNameList = new Vector.<String>();
			var ncNum:int = this.getNcNum();
			var nsNum:int = this.getNsNum();
			for(var i:int = 0;i<ncNum;i ++){
				var ncName:String = "nc_" + i;
				var nc:UUNetConnection = new UUNetConnection();
				var uuid:String = UUID.create();
				nc.client = this;
				nc.uuconnect(rtmpUrl);
				setMsg("链接服务器： "+rtmpUrl);
				nc.addEventListener(NetStatusEvent.NET_STATUS,handlerNcStatus);
			}
		}
		
		/**
		 * 事件	链接成功
		 * @param e
		 * 
		 */		
		private function handlerNcStatus(e:NetStatusEvent):void{
			if(e.info.code == NSICode.NetConnection_Connect_Success){
				var nc:UUNetConnection = e.currentTarget as UUNetConnection;
				ncList.push(nc);
				refreshVideoList();
				setMsg("链接成功");
			}
		}
		
		/**
		 * 事件	发布按钮
		 * @param e
		 * 
		 */		
		private function handlerPublishBtnClick(e:Event):void{
			var nc:UUNetConnection = ncList[0];
			var ncc:NCCall = new NCCall(nc,"getId",getIdResult,null,nc.uuid);
			ncc.call();
		}
		
		/**
		 * 回调	 获得当前id
		 * @param obj
		 * 
		 */		
		private function getIdResult(obj:Object):void{
			var id:String = String(obj);
			clearPubNs();
			for(var i:int = 0;i<ncList.length;i ++){
				var nc:UUNetConnection = ncList[i];
				for(var j:int = 0;j<this.getNsNum();j ++){
					var videoName:String = "cid" + id + "nc" + i + "ns" + j;
					videoNameList.push(videoName);
					var ns:PubNetStream = new PubNetStream(nc,NetStream.CONNECT_TO_FMS);
					ns.setPerformTest(this);
					ns.bufferTime = getBufferTime();
					var sign:Boolean = false;
					if(isPubVideo() && camera != null){
						ns.attachCamera(camera);
						setMsg("发布视频");
						sign = true;
					}
					if(isPubAudio() && mic != null){
						ns.attachAudio(mic);
						setMsg("发布音频");
						sign = true;
					}
					if(sign){
						ns.uuPublish(videoName,NSPublishType.LIVE);
						nsPubList.push(ns);
						setMsg("发布成功：" +videoName);
						var ncc:NCCall = new NCCall(nc,"addVideo",addVideoResult,null,videoName);
						ncc.call();
					}
					else {
						setMsg("发布失败：音频、视频都没勾选");
					}
				}
			}
		}
		
		private function clearPubNs():void{
			for(var i:int = 0;i<nsPubList.length;i ++){
				var ns:PubNetStream = nsPubList[i];
				ns.close();
			}
			nsPubList = new Vector.<PubNetStream>();
		}
		
		private function addVideoResult(obj:Object):void{
			refreshVideoList();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerPlayBtnClick(e:Event):void{	
			
			playAllVideo();
		}
		
		private function handlerRefreshBtnClick(e:Event):void{
			refreshVideoList();
		}
		
		private function refreshVideoList():void{
			var nc:UUNetConnection = ncList[0];
			var ncc:NCCall = new NCCall(nc,"getVideoList",getPlayOneVideoListResult,null);
			ncc.call();
		}
		
		private function getPlayOneVideoListResult(obj:Object):void{
			var videoNameArray:Array = obj as Array;
			var videoListCB:ComboBox = this.getChildByName("videoListCB") as ComboBox;
			videoListCB.removeAll();
			videoListCB.addItem(ComboBoxUtil.creatCBIterm("请选择视频",null));
			setMsg("视频列表：" +videoNameArray.length);
			for(var i:int = 0;i<videoNameArray.length;i ++){
				var videoName:String = videoNameArray[i] as String;
				videoListCB.addItem(ComboBoxUtil.creatCBIterm(videoName,videoName));
			}
		}
		
		/**
		 * 
		 * @param obj
		 * 
		 */		
		private function delAllVideoResult(obj:Object):void{
			refreshVideoList();
			trace(obj);	
		}
		
		/**
		 * 播放全部视频 
		 * @param videoName
		 * 
		 */		
		public function playAllVideo():void{
			clearNsPlayList();
			setMsg("视频列表：" + videoNameList.length);
			for(var i:int = 0;i<videoNameList.length;i ++){
				var nc:UUNetConnection = ncList[i % ncList.length];
				var ns:PlayNetStream = new PlayNetStream(nc,NetStream.CONNECT_TO_FMS);
				ns.setPerformTest(this);
				ns.bufferTime = getBufferTime();
				var videoName:String = videoNameList[i] as String;
				ns.uuPlay(videoName);
				nsPlayList.push(ns);
				var video:Video = new Video();
				video.x = i * 5;
				video.attachNetStream(ns);
				setMsg("接收视频：" + videoName);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerVideoListCBChange(e:Event):void{
			var cb:ComboBox = e.currentTarget as ComboBox;
			var videoName:String = String(cb.value);
			if(videoName != null){
				var nc:UUNetConnection = ncList[0];
				playOneVideo(nc,videoName);
			}
		}
		
		/**
		 * 播放一个视频 
		 * @param nc
		 * @param videoName
		 * 
		 */		
		public function playOneVideo(nc:UUNetConnection,videoName:String):void{
			SpriteUtil.deleteAllChild(videosLayer);
			if(nsPlayOne != null){
				nsPlayOne.close();
			}
			nsPlayOne = new PlayNetStream(nc,NetStream.CONNECT_TO_FMS);
			nsPlayOne.setPerformTest(this);
			nsPlayOne.bufferTime = getBufferTime();
			nsPlayOne.uuPlay(videoName);
			var video:Video = new Video();
			videosLayer.addChild(video);
			video.attachNetStream(nsPlayOne);
		}
		
		private function clearNsPlayList():void{
			for(var i:int = 0;i<nsPlayList.length;i ++){
				var ns:PlayNetStream = nsPlayList[i];
				ns.close();
			}
			nsPlayList = new Vector.<PlayNetStream>();
		}
		
		
		/**
		 * 链接数 
		 * @return 
		 * 
		 */		
		private function getNcNum():int{
			return getTfdValue("ncNumTfd");
		}
		
		/**
		 * 流个数 
		 * @return 
		 * 
		 */		
		private function getNsNum():int{
			return getTfdValue("nsNumTfd");
		}
		
		private function getFRM():int{
			return getTfdValue("frmTfd");
		}
		
		private function getCameraWidth():int{
			return getTfdValue("widthTfd");
		}
		
		private function getCameraHeight():int{
			return getTfdValue("heightTfd");
		}
		
		private function getCameraQuality():int{
			return getTfdValue("qualityTfd");
		}
		
		private function getBufferTime():Number{
			return getTfdValue("bufferTfd"); 
		}
		
		private function getTfdValue(name:String):Number{
			var tfd:TextField = this.getChildByName(name) as TextField;
			return Number(tfd.text);
		}
		
		private function isPubVideo():Boolean{
			return getCheckBoxValue("videoCB");
		}
		
		private function isPubAudio():Boolean{
			return getCheckBoxValue("audioCB");
		}
		
		private function getCheckBoxValue(name:String):Boolean{
			var cb:CheckBox = this.getChildByName(name) as CheckBox;
			return cb.selected;
		}
		
		public function setMsg(msg:String):void{
			var ta:TextArea = this.getChildByName("msgTA") as TextArea;
			ta.appendText(msg + "    [" + int(Math.random() * 1000) + "]\n");
			ta.verticalScrollPosition = ta.maxVerticalScrollPosition;
		}
		
		/**
		 * camera 摄像头激活 
		 * @param event
		 * 
		 */		
		private function handlerCameraActivityEvent(event:ActivityEvent):void {
			//trace("handlerCameraActivityEvent: " + event);
		}
		
		/**
		 * 客户端回调方法，必须要有 
		 * 
		 */		
		public function onBWDone():void{
			trace("onBWDone");
		}
	}
}