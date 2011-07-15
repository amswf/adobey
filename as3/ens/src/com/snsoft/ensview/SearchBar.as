package com.snsoft.ensview {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class SearchBar extends MovieClip {

		public static const EVENT_SEARCH:String = "SEARCHBAR_EVENT_SEARCH";

		public static const EVENT_VIEW_LIST:String = "SEARCHBAR_EVENT_VIEW_LIST";

		private var dTextTfd:TextField;

		private var dSearchBtn:MovieClip;

		private var dListBtn:MovieClip;

		private var _isViewList:Boolean = true;

		private var _searchText:String = null;

		public function SearchBar() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			dTextTfd = this.getChildByName("textTfd") as TextField;
			dSearchBtn = this.getChildByName("searchBtn") as MovieClip;
			dListBtn = this.getChildByName("listBtn") as MovieClip;

			dSearchBtn.buttonMode = true;
			dSearchBtn.addEventListener(MouseEvent.CLICK, handlerSearch);

			dListBtn.buttonMode = true;
			dListBtn.addEventListener(MouseEvent.CLICK, handlerList);

		}

		private function handlerSearch(e:Event):void {
			_searchText = dTextTfd.text;
			this.dispatchEvent(new Event(EVENT_SEARCH));
		}

		private function handlerList(e:Event):void {
			_isViewList = !_isViewList;
			this.dispatchEvent(new Event(EVENT_VIEW_LIST));
		}

		public function get searchText():String {
			return _searchText;
		}

		public function get isViewList():Boolean {
			return _isViewList;
		}

	}
}
