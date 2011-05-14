package com.snsoft.tvc2.dataObject {
	import com.snsoft.util.rlm.rs.RSSound;

	import flash.display.DisplayObject;
	import flash.media.Sound;

	/**
	 * 声音对象
	 * @author Administrator
	 *
	 */
	public class SoundDO {

		//名称
		private var _name:String;

		//延时播放的时间（多长时间后开始播放）
		private var _timeOffset:int;

		//最小播放时长
		private var _timeLength:int;

		//最大播放时长
		private var _timeout:int;

		//文本
		private var _text:String;

		//文件地址
		private var _url:String;

		//声音列表
		private var _soundList:Vector.<Sound>;

		//声音
		private var _rsSound:RSSound;

		public function SoundDO() {
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get timeOffset():int {
			return _timeOffset;
		}

		public function set timeOffset(value:int):void {
			_timeOffset = value;
		}

		public function get timeLength():int {
			return _timeLength;
		}

		public function set timeLength(value:int):void {
			_timeLength = value;
		}

		public function get timeout():int {
			return _timeout;
		}

		public function set timeout(value:int):void {
			_timeout = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			_url = value;
		}

		public function get soundList():Vector.<Sound> {
			return _soundList;
		}

		public function set soundList(value:Vector.<Sound>):void {
			_soundList = value;
		}

		public function get rsSound():RSSound
		{
			return _rsSound;
		}

		public function set rsSound(value:RSSound):void
		{
			_rsSound = value;
		}


	}
}
