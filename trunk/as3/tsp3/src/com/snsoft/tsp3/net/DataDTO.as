package com.snsoft.tsp3.net {
	import flash.display.BitmapData;

	public class DataDTO {

		private var _img:BitmapData;

		private var _imgUrl:String;

		private var _text:String;

		private var _plugin:String;

		private var _disobj:String;

		private var _type:String;

		private var _id:String;

		private var _name:String;

		private var _params:Vector.<DataParam> = new Vector.<DataParam>();

		private var _images:Vector.<DataParam> = new Vector.<DataParam>();

		private var _files:Vector.<DataParam> = new Vector.<DataParam>();

		private var _audios:Vector.<DataParam> = new Vector.<DataParam>();

		private var _videos:Vector.<DataParam> = new Vector.<DataParam>();

		public function DataDTO() {

		}

		public function addParam(param:DataParam):void {
			_params.push(param);
		}

		public function addImage(image:DataParam):void {
			_images.push(image);
		}

		public function addFile(param:DataParam):void {
			_files.push(param);
		}

		public function addAudio(audio:DataParam):void {
			_audios.push(audio);
		}

		public function addVideo(video:DataParam):void {
			_videos.push(video);
		}

		public function get img():BitmapData {
			return _img;
		}

		public function set img(value:BitmapData):void {
			_img = value;
		}

		public function get imgUrl():String {
			return _imgUrl;
		}

		public function set imgUrl(value:String):void {
			_imgUrl = value;
		}

		public function get text():String {
			return _text;
		}

		public function set text(value:String):void {
			_text = value;
		}

		public function get plugin():String {
			return _plugin;
		}

		public function set plugin(value:String):void {
			_plugin = value;
		}

		public function get disobj():String {
			return _disobj;
		}

		public function set disobj(value:String):void {
			_disobj = value;
		}

		public function get params():Vector.<DataParam> {
			return _params;
		}

		public function set params(value:Vector.<DataParam>):void {
			_params = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function get id():String {
			return _id;
		}

		public function set id(value:String):void {
			_id = value;
		}

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		public function get files():Vector.<DataParam> {
			return _files;
		}

		public function set files(value:Vector.<DataParam>):void {
			_files = value;
		}

		public function get images():Vector.<DataParam> {
			return _images;
		}

		public function set images(value:Vector.<DataParam>):void {
			_images = value;
		}

		public function get audios():Vector.<DataParam> {
			return _audios;
		}

		public function set audios(value:Vector.<DataParam>):void {
			_audios = value;
		}

		public function get videos():Vector.<DataParam> {
			return _videos;
		}

		public function set videos(value:Vector.<DataParam>):void {
			_videos = value;
		}

	}
}
