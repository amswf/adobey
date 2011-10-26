package com.snsoft.tsp3.net {
	import com.snsoft.tsp3.XMLData;
	import com.snsoft.util.UUID;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]

	/**
	 *
	 * @author Administrator
	 *
	 */
	public class DataLoader extends EventDispatcher {

		private var url:String;

		private static const OPERATION:String = "operation";

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

		public function DataLoader() {
			super(null);
		}

		public function loadData(url:String, code:String, operation:String, params:ReqParams = null):void {
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
			trace(ul.data);
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
								if (dto.imgUrl != null && dto.imgUrl.length > 0) {
									rsImg.addResUrl(dto.imgUrl);
								}

								var imgs:Vector.<DataParam> = dto.images;
								if (imgs != null) {
									for (var k:int = 0; k < imgs.length; k++) {
										var pImgUrl:String = imgs[k].url;
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
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
			}
			loadImgs();
		}

		private function handlerLoadError(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}

		private function loadImgs():void {
			if (rsImg.urlList.length > 0) {
				var rlm:ResLoadManager = new ResLoadManager();
				rlm.addResSet(rsImg);
				rlm.addEventListener(Event.COMPLETE, handlerLoadImgCmp);
				rlm.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadError);
				rlm.load();
			}
			else {
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function handlerLoadImgCmp(e:Event):void {
			var len:int = rsImg.imageBmdList.length;
			if (len > 0) {
				for (var i:int = 0; i < _data.length; i++) {
					var ds:DataSet = _data[i];
					for (var j:int = 0; j < ds.dtoList.length; j++) {
						var dto:DataDTO = ds.dtoList[j];
						dto.img = rsImg.getImageByUrl(dto.imgUrl);

						var imgs:Vector.<DataParam> = dto.images;
						if (imgs != null) {
							for (var k:int = 0; k < imgs.length; k++) {
								var dp:DataParam = imgs[k];
								dp.img = rsImg.getImageByUrl(dp.url);
							}
						}
					}
				}
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
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

	}
}
