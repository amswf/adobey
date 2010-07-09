package com.snsoft.tvc2.dataObject{
	 
	import com.snsoft.tvc2.map.MapView;
	import com.snsoft.util.HashVector;
	
	import flash.display.DisplayObject;
	import flash.media.Sound;

	public class BizDO{
		
		// vars
		private var _varDOHv:HashVector = null;
		
		//data DO
		private var _dataDO:DataDO = null;
		
		//sounds
		private var _soundsHv:HashVector = null;
		
		//textOuts
		private var _textOutsHv:HashVector = null;
		
		//medias
		private var _mediasHv:HashVector = null;
		
		private var _type:String = null;
		
		private var _mapView:MapView = null;
		
		private var _distributeMap:DisplayObject = null;
		
		private var _mapName:String = null;
		
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

	}
}