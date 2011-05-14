package com.snsoft.tvc2.dataObject{
	 
	import com.snsoft.tvc2.map.MapView;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.rlm.rs.RSTextFile;
	
	import flash.display.DisplayObject;
	import flash.media.Sound;

	/**
	 * 业务类数据对象 
	 * @author Administrator
	 * 
	 */	
	public class BizDO{
		
		// 变量      VarDO 列表
		private var _varDOHv:HashVector = null;
		
		// 业务主数据
		private var _dataDO:DataDO = null;
		
		//声音 SoundsDO 列表
		private var _soundsHv:HashVector = null;
		
		//文本 TextOutsDO 列表
		private var _textOutsHv:HashVector = null;
		
		//图片/动画 MediasDO 列表
		private var _mediasHv:HashVector = null;
		
		//业务数据类型
		private var _type:String = null;
		
		//xml生成的地图
		private var _mapView:MapView = null;
		
		//图片或动画地图
		private var _distributeMap:DisplayObject = null;
		
		//地图名称
		private var _mapName:String = null;
		
		//地图XML资源集
		private var _mapRS:RSTextFile = null;
		
		public function BizDO()
		{
		}

		public function get varDOHv():HashVector
		{
			return _varDOHv;
		}

		public function set varDOHv(value:HashVector):void
		{
			_varDOHv = value;
		}

		public function get dataDO():DataDO
		{
			return _dataDO;
		}

		public function set dataDO(value:DataDO):void
		{
			_dataDO = value;
		}

		public function get soundsHv():HashVector
		{
			return _soundsHv;
		}

		public function set soundsHv(value:HashVector):void
		{
			_soundsHv = value;
		}

		public function get textOutsHv():HashVector
		{
			return _textOutsHv;
		}

		public function set textOutsHv(value:HashVector):void
		{
			_textOutsHv = value;
		}

		public function get mediasHv():HashVector
		{
			return _mediasHv;
		}

		public function set mediasHv(value:HashVector):void
		{
			_mediasHv = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get mapView():MapView
		{
			return _mapView;
		}

		public function set mapView(value:MapView):void
		{
			_mapView = value;
		}

		public function get distributeMap():DisplayObject
		{
			return _distributeMap;
		}

		public function set distributeMap(value:DisplayObject):void
		{
			_distributeMap = value;
		}

		public function get mapName():String
		{
			return _mapName;
		}

		public function set mapName(value:String):void
		{
			_mapName = value;
		}

		public function get mapRS():RSTextFile
		{
			return _mapRS;
		}

		public function set mapRS(value:RSTextFile):void
		{
			_mapRS = value;
		}


	}
}