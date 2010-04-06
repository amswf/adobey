package com.snsoft.map.file{
	import com.snsoft.map.MapAreaDO;
	import com.snsoft.map.MapPointsManager;
	import com.snsoft.map.WorkSpace;
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.XMLUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MapDataFileManager extends EventDispatcher {
		
		//加载外部XML完成事件类型
		public static const COMPLETE:String = Event.COMPLETE;
		
		//工作区数据对象
		private var _workSpaceDO:WorkSpaceDO = null;
		
		private var _workSpaceDOVector:Vector.<WorkSpaceDO> = new Vector.<WorkSpaceDO>();
		
		//地图存储文件基本名称 ws_1_2.xml
		public static const MAP_FILE_BASE_NAME:String = "ws";
		
		//地图存储文件基本名称 ws_1_2.xml
		public static const MAP_FILE_DEFAULT_NAME:String = "ws_1";
		
		//地图存储文件层分隔符  ws_1_2.xml
		public static const MAP_FILE_NAME_SPLIT:String = "_";
		
		//地图存储文件分层路径名 1x / 2x / 3x
		public static const MAP_FILE_LAYER_BASE_NAME:String = "x";
		
		//地图存储文件扩展名 ws_1_2.xml
		public static const MAP_FILE_BASE_EXT_NAME:String = ".xml";
		
		//存储根路径
		private static var _mainDirectory:String = null;
		
		public function MapDataFileManager() {
			
		}
		
		public function deleteAllChildDirectory():void{
			var dir:String = this.mainDirectory;
			if(dir != null){
				var file:File = new File(dir);
				if(file.isDirectory){
					var fileAry:Array = file.getDirectoryListing();
					if(fileAry != null){
						for(var i:int = 0;i<fileAry.length;i++){
							var cfile:File = fileAry[i] as File;
							if(cfile != null){
								if(cfile.isDirectory){
									 cfile.deleteDirectory(true);
								}
								else{
									cfile.deleteFile();
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * 创建地图保存完整路径 
		 * @param dir
		 * @param parentName
		 * @return 
		 * 
		 */		
		public function creatFileFullPath(parentWsName:String = MAP_FILE_BASE_NAME):String{
			var dir:String = this.mainDirectory;
			if(dir != null){
				var nxName:String = getNxPath(dir,parentWsName);
				return nxName + File.separator + creatFileName(dir,parentWsName) + MAP_FILE_BASE_EXT_NAME;
			}
			return null;
		} 
		
		/**
		 * 创建地图保存名称 
		 * @param dir
		 * @param parentWsName
		 * @return 
		 * 
		 */		
		public function creatFileName(dir:String,parentWsName:String = MAP_FILE_BASE_NAME):String{
			var newFileName:String = null;
			var nxName:String = getNxPath(dir,parentWsName);
			var nx:File = new File(nxName);
			if(nx.isDirectory){
				var files:Array = nx.getDirectoryListing();
				if(files.length > 0){
					for(var n:int =1;n<files.length;n++){
						var childWsName:String = createChildWorkSpaceName(parentWsName,n);
						var fullPath:String = nxName + File.separator + childWsName + MAP_FILE_BASE_EXT_NAME;
						var hasSameName:Boolean = false;
						if(!fileIsExists(fullPath)){
							newFileName = childWsName;
						}
					}
				}
			}
			if(newFileName == null) {
				var childWsName2:String = createChildWorkSpaceName(parentWsName,1);
				newFileName = childWsName2;
			}
			return newFileName;
		}
		
		/**
		 * 删除文件 
		 * @param fullPath
		 * 
		 */			
		public function deleteFile(fullPath:String):void{
			if(fileIsExists(fullPath)){
				var file:File = new File(fullPath);
				file.deleteFile();
			}
		}
		
		/**
		 * 获得工作区的层完整路径 
		 * @param dir
		 * @param wsName
		 * @return 
		 * 
		 */		
		private function getNxPath(dir:String,wsName:String):String{
			var layer:int =1 + getFileLayerByName(wsName + MAP_FILE_BASE_EXT_NAME);
			var nxName:String = dir + File.separator + layer + MAP_FILE_LAYER_BASE_NAME;
			return nxName;
		}
		
		/**
		 *  
		 * @param wsName
		 * @return 
		 * 
		 */		
		public function creatFileFullPath2(wsName:String):String{
			var dir:String = this.mainDirectory;
			if(dir != null){
				var nxName:String = getNxPath2(dir,wsName);
				return nxName + File.separator + wsName + MAP_FILE_BASE_EXT_NAME;
			}
			return null;
		} 
		
		/**
		 * 
		 * @param dir
		 * @param wsName
		 * @return 
		 * 
		 */		
		private function getNxPath2(dir:String,wsName:String):String{
			var layer:int =getFileLayerByName(wsName + MAP_FILE_BASE_EXT_NAME);
			var nxName:String = dir + File.separator + layer + MAP_FILE_LAYER_BASE_NAME;
			return nxName;
		}
		
		
		
		/**
		 * 查找文件是否存在 
		 * @param fullPath
		 * @return 
		 * 
		 */		
		public function fileIsExists(fullPath:String):Boolean{
			var exists:Boolean = false;
			if(fullPath != null && fullPath.length > 0){
				var newFile:File = new File(fullPath);
				if(newFile.exists){
					exists = newFile.exists;
				}
			}
			return exists;
		}
		
		/**
		 * 获得文件存放所在的层次 
		 * @param fileName
		 * @return 
		 * 
		 */		
		private function getFileLayerByName(fileName:String):int{
			
			var num:int = 0;
			if(fileName != null && fileName.length > 0){
				for(var i:int = 0;i<fileName.length;i++){
					if(fileName.charAt(i) == MAP_FILE_NAME_SPLIT){
						num ++;
					}
				}
			}
			return num;
		}
		
		/**
		 * 创建子工作区基本名称 
		 * @param parentWorkSpaceName
		 * @return 
		 * 
		 */		
		public static function createChildWorkSpaceName(parentWorkSpaceName:String = null,i:int = 0):String{
			var wsName:String = MAP_FILE_BASE_NAME;
			if(parentWorkSpaceName == null && parentWorkSpaceName.length == 0){
				wsName = parentWorkSpaceName;
			}
			else {
				wsName = parentWorkSpaceName + MAP_FILE_NAME_SPLIT + i;
			}
			return wsName;
		}
		
		/**
		 * 创建父工作区基本名称 
		 * @param parentWorkSpaceName
		 * @return 
		 * 
		 */		
		public static function createParentWorkSpaceName(childWorkSpaceName:String = null):String{
			var wsName:String = null;
			if(childWorkSpaceName != null){
				var index:int = childWorkSpaceName.lastIndexOf("_");
				if(index >= 0){
					wsName = childWorkSpaceName.substring(0,index);
				}
			}
			return wsName;
		}
		
		/**
		 * 创建工作区父工作区名称
		 * @param workSpaceName
		 * @return 
		 * 
		 */		
		private static function createParentWorkSpaceBaseName(workSpaceName:String):String{
			var wsName:String = null;
			if(workSpaceName == null && workSpaceName.length == 0){
				
			}
			else {
				var li:int = workSpaceName.lastIndexOf(MAP_FILE_NAME_SPLIT);
				wsName = workSpaceName.substring(0,li);
			}
			return wsName;
		}
		
		
		public function open(dir:String):void {
			var req:URLRequest = new URLRequest(dir);
			var loader:URLLoader = new URLLoader();
			loader.load(req);
			loader.addEventListener(Event.COMPLETE,handlerLoaderXML);
			
			/*文件加载方式
			var file:File = new File(dir);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			trace(new XML(fs.readUTFBytes(fs.bytesAvailable)));
			*/
		}
		
		private function handlerLoaderXML(e:Event):void {
			var map:XML = new XML(e.currentTarget.data);
			var wsdo:WorkSpaceDO = this.creatWorkSpaceDO(map,null);
			this._workSpaceDO = wsdo;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 
		 * 
		 */		
		public function openAll():void{
			var dir:String = this.mainDirectory;
			if(dir != null){
				var dfv:Vector.<File> = this.getAllDataFile();
				loadAllDataFile(dfv,0);
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		private function getAllDataFile():Vector.<File>{
			var dir:String = this.mainDirectory;
			var v:Vector.<File> = new Vector.<File>();
			if(dir != null){
				var rootDirFile:File = new File(dir);
				if(rootDirFile.exists){
					var nxDirFileList:Array = rootDirFile.getDirectoryListing();
					for(var i:int = 0;i<nxDirFileList.length;i++){
						var nxDirFile:File = nxDirFileList[i] as File;
						if(nxDirFile.isDirectory){
							var dataFileList:Array = nxDirFile.getDirectoryListing();
							for(var j:int = 0;j < dataFileList.length;j ++){
								var dataFile:File = dataFileList[j] as File;
								if(!dataFile.isDirectory){
									v.push(dataFile);
								}
							}
						}
					}
				}
			}
			return v;
		}
		
		
		private var wsName:String = null;
		
		private var nextIndex:int = 0;
		
		private var dataFileVector:Vector.<File> = null;
		/**
		 * 
		 * @param v
		 * @param index
		 * 
		 */		
		private function loadAllDataFile(v:Vector.<File>,index:int):void{
			if(v != null && index >= 0 && index < v.length){
				nextIndex = index;
				dataFileVector = v;
				var dataFile:File = v[index];
				var name:String = dataFile.name;
				wsName = name.replace(MAP_FILE_BASE_EXT_NAME,"");
				var dir:String = dataFile.nativePath;
				var req:URLRequest = new URLRequest(dir);
				var loader:URLLoader = new URLLoader();
				loader.load(req);
				loader.addEventListener(Event.COMPLETE,handlerLoadAllDataFile); 
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerLoadAllDataFile(e:Event):void{
			var map:XML = new XML(e.currentTarget.data);
			var wsdo:WorkSpaceDO = this.creatWorkSpaceDO(map,wsName);
			this._workSpaceDOVector.push(wsdo);
			nextIndex ++;
			if(nextIndex < dataFileVector.length){
				loadAllDataFile(dataFileVector,nextIndex);
			}
			else{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 把XML数据转换成工作区对象 
		 * @param xml
		 * @return 
		 * 
		 */		
		public function creatWorkSpaceDO(xml:XML,wsName:String):WorkSpaceDO{
			var wsdo:WorkSpaceDO = new WorkSpaceDO();
			//<map> 
			var map:XML = xml;
			
			//<image>
			var image:XML = map.elements("image")[0];
			var mapImage:String = image.text();
			wsdo.image = mapImage;
			wsdo.wsName = wsName;
			
			//工作区地图块数据对象列表
			var madoha:HashVector = new HashVector  ;
			//<areas>
			var areas:XMLList = map.elements("areas").children();
			if (areas != null) {
				for (var i:int = 0; i<areas.length(); i++) {
					
					//<area>
					var area:XML = areas[i];
					if (area != null) {
						//地图块数据对象
						var mado:MapAreaDO = new MapAreaDO();
						
						//<areaId>
						var areaId:XML = area.elements("areaId")[0];
						var mapAreaId:String = areaId.text();
						mado.areaId = mapAreaId;
						
						//<areaName>
						var areaName:XML = area.elements("areaName")[0];
						var mapAreaName:String = areaName.text();
						mado.areaName = mapAreaName;
						
						//<areaNamePoint>
						var areaNamePoint:XML = area.elements("areaNamePoint")[0];
						if (areaNamePoint != null) {
							var apx:XML = areaNamePoint.elements("x")[0];
							var apy:XML = areaNamePoint.elements("y")[0];
							var mapap:Point = new Point();
							if (apx != null && apy != null) {
								if (apx.text() != null && apy.text() != null) {
									mapap = new Point(Number(apx.text()),Number(apy.text()));
								}
							}
							mado.areaNamePlace = mapap;
						}
						
						//地图块的点列
						var pha:HashVector = new HashVector();
						//<areaPoints>
						var areaPoints:XML = area.elements("areaPoints")[0];
						if (areaPoints != null) {
							var areaPointsChilds:XMLList = areaPoints.children();
							for (var j:int = 0; j<areaPointsChilds.length(); j++) {
								var areaPoint:XML = areaPointsChilds[j];
								if (areaPoint != null) {
									var px:XML = areaPoint.elements("x")[0];
									var py:XML = areaPoint.elements("y")[0];
									var p:Point = new Point();
									if (px != null && py != null) {
										if (px.text() != null && py.text() != null) {
											p = new Point(Number(px.text()),Number(py.text()));
											var name:String = MapPointsManager.createPointHashName(p);
											pha.put(name,p);
										}
									}
								}
							}
						}
						mado.pointArray = pha;
						var haName:String = MapPointsManager.creatHashArrayHashName(pha);
						madoha.put(haName,mado);
					}
				}
			}
			wsdo.mapAreaDOHashArray = madoha;
			return wsdo;
		}
		
		public function save(ws:WorkSpace,filePath:String):void {
			var xml:String = creatXML(ws);
			xml = XMLUtil.formatXML(new XML(xml));
			var file:File = new File(filePath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			
			fs.writeUTFBytes(xml);
			fs.close();
		}
		
		private function creatXML(ws:WorkSpace):String {
			var madoa:HashVector = ws.manager.mapAreaDOAry as HashVector;
			var image:String = "";
			if (ws.mapImage != null && ws.mapImage.imageUrl != null) {
				image = ws.mapImage.imageUrl;
			}
			var xml:String = new String();
			xml = xml.concat("<map>");
			
			xml = xml.concat("<image>");
			xml = xml.concat(image);
			xml = xml.concat("</image>");
			
			xml = xml.concat("<areas>");
			if (madoa != null) {
				for (var i:int = 0; i<madoa.length; i++) {
					var mado:MapAreaDO = madoa.findByIndex(i) as MapAreaDO;
					var name:String = mado.areaName;
					var id:String = mado.areaId;
					var placeP:Point = mado.areaNamePlace;
					var pha:HashVector = mado.pointArray;
					xml = xml.concat("<area>");
					
					
					xml = xml.concat("<areaId>");
					xml = xml.concat(id);
					xml = xml.concat("</areaId>");
					
					xml = xml.concat("<areaName>");
					xml = xml.concat(name);
					xml = xml.concat("</areaName>");
					
					xml = xml.concat("<areaNamePoint>");
					
					xml = xml.concat("<x>");
					xml = xml.concat(placeP.x);
					xml = xml.concat("</x>");
					
					xml = xml.concat("<y>");
					xml = xml.concat(placeP.y);
					xml = xml.concat("</y>");
					
					xml = xml.concat("</areaNamePoint>");
					
					xml = xml.concat("<areaPoints>");
					if (pha != null) {
						for (var j:int = 0; j < pha.length; j++) {
							var ap:Point = pha.findByIndex(j) as Point;
							xml = xml.concat("<point>");
							
							xml = xml.concat("<x>");
							xml = xml.concat(ap.x);
							xml = xml.concat("</x>");
							
							xml = xml.concat("<y>");
							xml = xml.concat(ap.y);
							xml = xml.concat("</y>");
							
							xml = xml.concat("</point>");
						}
					}
					
					xml = xml.concat("</areaPoints>");
					
					xml = xml.concat("</area>");
				}
			}
			xml = xml.concat("</areas>");
			xml = xml.concat("</map>");
			return xml;
		}
		
		public function get workSpaceDO():WorkSpaceDO {
			return _workSpaceDO;
		}

		public function get mainDirectory():String
		{
			return _mainDirectory;
		}

		public function set mainDirectory(value:String):void
		{
			_mainDirectory = value;
		}

		public function get workSpaceDOVector():Vector.<WorkSpaceDO>
		{
			return _workSpaceDOVector;
		}
	}
}