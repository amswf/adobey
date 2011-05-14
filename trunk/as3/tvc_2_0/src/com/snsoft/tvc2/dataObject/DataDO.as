package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.rlm.rs.RSSound;
	
	import flash.media.Sound;
	
	/**
	 * 业务主数据对象
	 * @author Administrator
	 * 
	 */	
	public class DataDO{
		
		//类型
		private var _type:String = null;
		
		//主数据
		private var _data:Vector.<ListDO> = null;
		
		//x 坐标刻度文本
		private var _xGraduationText:Vector.<ListDO> = null;
		
		//y 坐标刻度文本
		private var _yGraduationText:Vector.<ListDO> = null;
		
		//价格分布业务价格播报数据列表
		private var _broadcast:Vector.<ListDO> = null;
		
		//价格分析集中地区信息列表
		private var _des:Vector.<ListDO> = null;
		
		//x 轴数值单位
		private var _unitX:String;
		
		//y 轴数据单位
		private var _unitY:String;
		
		//业务语音列表
		private var _bizSoundList:Vector.<Vector.<Sound>> = null;
		
		//业务语音文本列表
		private var _bizSoundTextList:Vector.<Vector.<String>> = null;
		
		//业务语音资源集
		private var _resSetList:Vector.<RSSound> = null;
		
		public function DataDO()
		{
		}

		public function get data():Vector.<ListDO>
		{
			return _data;
		}

		public function set data(value:Vector.<ListDO>):void
		{
			_data = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get xGraduationText():Vector.<ListDO>
		{
			return _xGraduationText;
		}

		public function set xGraduationText(value:Vector.<ListDO>):void
		{
			_xGraduationText = value;
		}

		public function get yGraduationText():Vector.<ListDO>
		{
			return _yGraduationText;
		}

		public function set yGraduationText(value:Vector.<ListDO>):void
		{
			_yGraduationText = value;
		}

		public function get broadcast():Vector.<ListDO>
		{
			return _broadcast;
		}

		public function set broadcast(value:Vector.<ListDO>):void
		{
			_broadcast = value;
		}

		public function get unitX():String
		{
			return _unitX;
		}

		public function set unitX(value:String):void
		{
			_unitX = value;
		}

		public function get unitY():String
		{
			return _unitY;
		}

		public function set unitY(value:String):void
		{
			_unitY = value;
		}

		public function get bizSoundList():Vector.<Vector.<Sound>>
		{
			return _bizSoundList;
		}

		public function set bizSoundList(value:Vector.<Vector.<Sound>>):void
		{
			_bizSoundList = value;
		}

		public function get bizSoundTextList():Vector.<Vector.<String>>
		{
			return _bizSoundTextList;
		}

		public function set bizSoundTextList(value:Vector.<Vector.<String>>):void
		{
			_bizSoundTextList = value;
		}

		public function get des():Vector.<ListDO>
		{
			return _des;
		}

		public function set des(value:Vector.<ListDO>):void
		{
			_des = value;
		}

		public function get resSetList():Vector.<RSSound>
		{
			return _resSetList;
		}

		public function set resSetList(value:Vector.<RSSound>):void
		{
			_resSetList = value;
		}

		 


	}
}