package com.snsoft.tsp3.net {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.XMLData;
	import com.snsoft.util.UUID;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	[Event(name = "timeOut", type = "com.snsoft.tsp3.net.DataLoaderEvent")]

	/**
	 *
	 * @author Administrator
	 *
	 */
	public class DataLoader extends EventDispatcher {

		private var url:String;

		private static const OPERATION:String = "operation";

		private var rsIcon:RSImages = new RSImages();

		private var rsImg:RSImages = new RSImages();

		private var _data:Vector.<DataSet> = new Vector.<DataSet>();

		private const TAG_SET:String = "recordset";

		private const TAG_DTO:String = "record";

		private const TAG_PARAMS:String = "params";

		private const TAG_PARAM:String = "param";

		private const TAG_IMAGES:String = "images";

		private const TAG_IMAGE:String = "image";

		private const TAG_FILES:String = "files";

		private const TAG_FILE:String = "file";

		private const TAG_AUDIOS:String = "audios";

		private const TAG_AUDIO:String = "audio";

		private const TAG_VIDEOS:String = "videos";

		private const TAG_VIDEO:String = "video";

		private var lockTimer:Timer;

		private var isTimeOut:Boolean = false;

		public function DataLoader() {
			super(null);
			lockTimer = new Timer(Common.REQ_DELAY_TIME, 1);
			lockTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handlerLockTimerCmp);
		}

		private function handlerLockTimerCmp(e:Event):void {
			isTimeOut = true;
			this.dispatchEvent(new Event(DataLoaderEvent.TIME_OUT));
		}

		public function loadData(url:String, code:String, operation:String, params:ReqParams = null):void {
			timerStart();
			this.url = url;
			if (params == null) {
				params = new ReqParams();
			}
			params.addParam(OPERATION, operation);

			trace("xml url:", url);
			trace("xml req:", params.toXML());
			var uvs:URLVariables = new URLVariables();
			uvs["code"] = code;
			uvs["xml"] = params.toXML();
			load(url, uvs);
		}

		private function load(url:String, uvs:URLVariables = null):void {

			var req:URLRequest = new URLRequest(url);
			if (uvs == null) {
				uvs = new URLVariables();
			}
			var uuid:String = UUID.create();
			uvs[uuid] = uuid;
			req.data = uvs;
			req.method = URLRequestMethod.POST;

			var ul:URLLoader = new URLLoader();
			ul.addEventListener(Event.COMPLETE, handlerLoadCmp);
			ul.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadError);
			ul.load(req);
		}

		private function handlerLoadCmp(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			trace("xml back:*********************************************************************************");
			//trace(ul.data);
			var xd:XMLData = new XMLData(ul.data);
			if (xd.isCmp) {
				var list:NodeList = xd.bodyNode.getNodeList(TAG_SET);
				if (list != null) {
					_data = new Vector.<DataSet>();
					for (var i:int = 0; i < list.length(); i++) {
						var setNode:Node = list.getNode(i);
						var dtoList:NodeList = setNode.getNodeList(TAG_DTO);
						var ds:DataSet = new DataSet();
						setNode.attrToObj(ds.attr);
						if (dtoList != null) {
							for (var j:int = 0; j < dtoList.length(); j++) {
								var dtoNode:Node = dtoList.getNode(j);
								var dto:DataDTO =  creatToolBarBtnDTO(dtoNode);
								ds.addDto(dto);

								if (dto.imgUrl == null || dto.imgUrl.length == 0) {
									dto.imgUrl = Common.DEF_IC0N_URL;
								}
								rsIcon.addResUrl(dto.imgUrl);
								if (dto.titleImgUrl == null || dto.titleImgUrl.length == 0) {
									dto.titleImgUrl = Common.DEF_IC0N_URL;
								}
								rsIcon.addResUrl(dto.titleImgUrl);
								var imgs:Vector.<DataParam> = dto.images;
								if (imgs != null) {
									for (var k:int = 0; k < imgs.length; k++) {
										var pImgUrl:String = imgs[k].url;
										if (pImgUrl == null || pImgUrl.length == 0) {
											pImgUrl = Common.DEF_IMG_URL;
										}
										rsImg.addResUrl(pImgUrl);
									}
								}
							}
						}
						_data.push(ds);
					}
				}
			}
			else {
				dispachEventIOError();
			}
			loadImgs();
		}

		private function handlerLoadError(e:Event):void {
			dispachEventIOError();
		}

		private function loadImgs():void {
			if (Common.instance().defIcon == null) {
				rsIcon.addResUrl(Common.DEF_IC0N_URL);
			}
			if (Common.instance().defImg == null) {
				rsImg.addResUrl(Common.DEF_IMG_URL);
			}
			if (rsImg.urlList.length > 0 || rsIcon.urlList.length > 0) {
				var rlm:ResLoadManager = new ResLoadManager();
				rlm.addResSet(rsIcon);
				rlm.addResSet(rsImg);
				rlm.addEventListener(Event.COMPLETE, handlerLoadImgCmp);
				rlm.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadError);
				rlm.load();
			}
			else {
				dispachEventCmp();
			}
		}

		private function handlerLoadImgCmp(e:Event):void {
			if (Common.instance().defIcon == null) {
				Common.instance().initDefIcon(rsIcon.getImageByUrl(Common.DEF_IC0N_URL));
			}
			if (Common.instance().defImg == null) {
				Common.instance().initDefImg(rsImg.getImageByUrl(Common.DEF_IMG_URL));
			}
			var iconlen:int = rsIcon.imageBmdList.length;
			var imglen:int = rsImg.imageBmdList.length;
			if (iconlen > 0 || imglen > 0) {
				for (var i:int = 0; i < _data.length; i++) {
					var ds:DataSet = _data[i];
					for (var j:int = 0; j < ds.dtoList.length; j++) {
						var dto:DataDTO = ds.dtoList[j];
						dto.img = safeIcon(rsIcon.getImageByUrl(dto.imgUrl));
						dto.titleImg = safeIcon(rsIcon.getImageByUrl(dto.titleImgUrl));
						var imgs:Vector.<DataParam> = dto.images;
						if (imgs != null) {
							for (var k:int = 0; k < imgs.length; k++) {
								var dp:DataParam = imgs[k];
								dp.img = safeImg(rsImg.getImageByUrl(dp.url));
							}
						}
					}
				}
			}
			dispachEventCmp();
		}

		private function dispachEventIOError():void {
			if (!isTimeOut) {
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			}
		}

		private function dispachEventCmp():void {
			if (!isTimeOut) {
				timerStop();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function safeIcon(img:BitmapData):BitmapData {
			var bmd:BitmapData = img;
			if (bmd == null) {
				bmd = Common.instance().defIcon;
			}
			return bmd;
		}

		private function safeImg(img:BitmapData):BitmapData {
			var bmd:BitmapData = img;
			if (bmd == null) {
				bmd = Common.instance().defImg;
			}
			return bmd;
		}

		private function creatToolBarBtnDTO(node:Node):DataDTO {
			var dto:DataDTO = new DataDTO();
			node.attrToObj(dto);
			params(dto, node, TAG_PARAMS, TAG_PARAM);
			params(dto, node, TAG_IMAGES, TAG_IMAGE);
			params(dto, node, TAG_FILES, TAG_FILE);
			params(dto, node, TAG_AUDIOS, TAG_AUDIO);
			params(dto, node, TAG_VIDEOS, TAG_VIDEO);
			return dto;
		}

		private function params(dto:DataDTO, node:Node, listTag:String, nodeTag:String):void {
			var paramsNode:Node = node.getNodeListFirstNode(listTag);
			if (paramsNode != null) {
				var paramList:NodeList = paramsNode.getNodeList(nodeTag);
				if (paramList != null && paramList.length() > 0) {
					var pv:Vector.<DataParam> = new Vector.<DataParam>();
					for (var i:int = 0; i < paramList.length(); i++) {
						var paramNode:Node = paramList.getNode(i);
						var param:DataParam = new DataParam();
						paramNode.attrToObj(param);
						param.content = paramNode.text;
						pv.push(param)
					}
					dto[listTag] = pv;
				}
			}
		}

		public function get data():Vector.<DataSet> {
			return _data;
		}

		private function timerStart():void {
			lockTimer.start();
		}

		private function timerStop():void {
			lockTimer.stop();
		}

	}
}
