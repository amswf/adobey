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

		public function DataLoader() {
			super(null);
		}

		public function loadData(url:String, code:String, operation:String, params:Params = null):void {
			this.url = url;
			if (params == null) {
				params = new Params();
			}
			params.addParam(OPERATION, operation);

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
							}
						}
						_data.push(ds);
					}
				}
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
					}
				}
			}
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		private function creatToolBarBtnDTO(node:Node):DataDTO {
			var dto:DataDTO = new DataDTO();
			node.attrToObj(dto);
			var params:Object = new Object();
			var paramsNode:Node = node.getNodeListFirstNode(TAG_PARAMS);
			paramsNode.attrToObj(params);
			paramsNode.childNodeTextTObj(params);
			dto.params = params;
			return dto;
		}

		public function get data():Vector.<DataSet> {
			return _data;
		}

	}
}
