package com.snsoft.fmc.test{
	import com.snsoft.fmc.NCCall;
	import com.snsoft.fmc.NSICode;
	import com.snsoft.fmc.NSPublishType;
	import com.snsoft.fmc.test.vi.UUNetConnection;
	import com.snsoft.util.ComboBoxUtil;
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.UUID;
	import com.snsoft.xmldom.XMLFastConfig;
	
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
	
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
		
		private var nsPlayList:Vector.<NetStream> = new Vector.<NetStream>();
		
		private var nsPubList:Vector.<NetStream> = new Vector.<NetStream>();
		
		private var videosLayer:Sprite = new Sprite();
		
		private var videoNameList:Vector.<String>;
		
		private var ns:NetStream;
		
		public function PerformTest()
		{
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			super();
		}
		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
			this.addChild(videosLayer);
			
			creatMicAndVideo();
			
			var connectBtn:Button = this.getChildByName("connectBtn") as Button;
			connectBtn.addEventListener(MouseEvent.CLICK,handlerConnectBtnClick);
			
			var publishBtn:Button = this.getChildByName("publishBtn") as Button;
			publishBtn.addEventListener(MouseEvent.CLICK,handlerPublishBtnClick);
			
			var playBtn:Button = this.getChildByName("playBtn") as Button;
			playBtn.addEventListener(MouseEvent.CLICK,handlerPlayBtnClick);
			
			var delBtn:Button = this.getChildByName("delBtn") as Button;
			delBtn.addEventListener(MouseEvent.CLICK,handlerDelBtnClick);
			
			
			var refreshBtn:Button = this.getChildByName("refreshBtn") as Button;
			refreshBtn.addEventListener(MouseEvent.CLICK,handlerRefreshBtnClick);
			
			var videoListCB:ComboBox = this.getChildByName("videoListCB") as ComboBox;
			videoListCB.addEventListener(Event.CHANGE,handlerVideoListCBChange);
			
			
			var cameraBtn:Button = this.getChildByName("cameraBtn") as Button;
			cameraBtn.addEventListener(MouseEvent.CLICK,handlerCameraBtnClick);
			
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
		}
			
		
		private function handlerCameraBtnClick(e:Event):void{
			setMsg("设置摄像头");
			camera.setMode(getCameraWidth(),getCameraHeight(),getFRM(),false);
			camera.setQuality(getCameraQuality()* 800,0);
		}
		
		private function creatMicAndVideo():void{
			mic = Microphone.getMicrophone();
			camera = Camera.getCamera();
			
			if(camera != null && mic != null){
				trace(camera.fps);
				camera.setKeyFrameInterval(15);
				camera.setMode(400,300,15,false);
				camera.setQuality(48000,0);
				camera.addEventListener(ActivityEvent.ACTIVITY,handlerCameraActivityEvent);
				
				var localVideo:Video = new Video(200,150);
				localVideo.x = 400 ;
				localVideo.y = 0;
				localVideo.attachCamera(camera);
				this.addChild(localVideo);
				
				mic.setLoopBack(false);
				mic.setUseEchoSuppression(true);
			}
		}
		
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
		 * 
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
		 * 
		 * @param e
		 * 
		 */		
		private function handlerPublishBtnClick(e:Event):void{
			var nc:UUNetConnection = ncList[0];
			var ncc:NCCall = new NCCall(nc,"getId",getIdResult,null,nc.uuid);
			ncc.call();
		}
		
		private function getIdResult(obj:Object):void{
			var id:String = String(obj);
			
			clearPubNs();
			for(var i:int = 0;i<ncList.length;i ++){
				var nc:UUNetConnection = ncList[i];
				for(var j:int = 0;j<this.getNsNum();j ++){
					var videoName:String = "cid" + id + "nc" + i + "ns" + j;
					videoNameList.push(videoName);
					var ns:NetStream = new NetStream(nc,NetStream.CONNECT_TO_FMS);
					ns.bufferTime = getBufferTime();
					if(isPubVideo()){
						ns.attachCamera(camera);
						setMsg("发布视频");
					}
					if(isPubAudio()){
						ns.attachAudio(mic);
						setMsg("发布音频");
					}
					ns.publish(videoName,NSPublishType.APPEND);
					nsPubList.push(ns);
					setMsg("发布视频成功：" +videoName);
					var ncc:NCCall = new NCCall(nc,"addVideo",addVideoResult,null,videoName);
					ncc.call();
				}
			}
		}
		
		private function clearPubNs():void{
			for(var i:int = 0;i<nsPubList.length;i ++){
				var ns:NetStream = nsPubList[i];
				ns.close();
			}
			nsPubList = new Vector.<NetStream>();
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
		
		private function handlerDelBtnClick(e:Event):void{	
			
			var nc:UUNetConnection = ncList[0];
			var ncc:NCCall = new NCCall(nc,"delAllVideo",delAllVideoResult,null);
			ncc.call();
		}
		
		private function handlerRefreshBtnClick(e:Event):void{
			refreshVideoList();
		}
		
		private function refreshVideoList():void{
			var nc:UUNetConnection = ncList[0];
			var ncc:NCCall = new NCCall(nc,"getVideoList",getPlayOneVideoListResult,null);
			ncc.call();
		}
		
		private function handlerVideoListCBChange(e:Event):void{
			var cb:ComboBox = e.currentTarget as ComboBox;
			var videoName:String = String(cb.value);
			if(videoName != null){
				var nc:UUNetConnection = ncList[0];
				playOneVideo(nc,videoName);
			}
		}
		
		
		private function getPlayOneVideoListResult(obj:Object):void{
			var videoNameArray:Array = obj as Array;
			var videoListCB:ComboBox = this.getChildByName("videoListCB") as ComboBox;
			videoListCB.removeAll();
			videoListCB.addItem(ComboBoxUtil.creatCBIterm("请选择视频",null));
			for(var i:int = 0;i<videoNameArray.length;i ++){
				var videoName:String = videoNameArray[i] as String;
				videoListCB.addItem(ComboBoxUtil.creatCBIterm(videoName,videoName));
			}
		}
		
		
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
			removePlayer();
			setMsg("视频列表：" + videoNameList.length);
			for(var i:int = 0;i<videoNameList.length;i ++){
				var nc:UUNetConnection = ncList[i % ncList.length];
				var ns:NetStream = new NetStream(nc,NetStream.CONNECT_TO_FMS);
				ns.bufferTime = getBufferTime();
				var videoName:String = videoNameList[i] as String;
				ns.play(videoName);
				nsPlayList.push(ns);
				var video:Video = new Video();
				video.x = i * 5;
				video.attachNetStream(ns);
				setMsg("接收视频：" + videoName);
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
			if(ns != null){
				ns.close();
			}
			ns = new NetStream(nc,NetStream.CONNECT_TO_FMS);
			ns.bufferTime = 0.5;
			ns.play(videoName);
			var video:Video = new Video();
			videosLayer.addChild(video);
			video.attachNetStream(ns);
		}
		
		private function removePlayer():void{
			SpriteUtil.deleteAllChild(videosLayer);
			for(var i:int = 0;i<nsPlayList.length;i ++){
				var ns:NetStream = nsPlayList[i];
				ns.close();
			}
			nsPlayList = new Vector.<NetStream>();
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
		
		private function setMsg(msg:String):void{
			var ta:TextArea = this.getChildByName("msgTA") as TextArea;
			ta.text += msg + "    [" + int(Math.random() * 1000) + "]\r";
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