package com.snsoft.tvc2.mediaEditer{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class Media extends UIComponent{
		
		private var _tfd:TextField;
		
		private var _placeType:String;
		
		private var _style:String;
		
		private var _text:String;
		
		public function Media(text:String,placeType:String,style:String){
			super();
			this.placeType = placeType;
			this.style = style;
			this.text = text;
		}
		
		override protected function configUI():void{
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		override protected function draw():void{
			SpriteUtil.deleteAllChild(this);
			tfd = EffectText.creatTextByStyleName(text,style);
			tfd.name = text;
			this.addChild(tfd);
			//this.dispatchEvent(new Event(EVENT_PLAYED));
		}
		
		public function get placeType():String
		{
			return _placeType;
		}

		public function set placeType(value:String):void
		{
			_placeType = value;
		}

		public function get style():String
		{
			return _style;
		}

		public function set style(value:String):void
		{
			_style = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get tfd():TextField
		{
			return _tfd;
		}

		public function set tfd(value:TextField):void
		{
			_tfd = value;
		}


	}
}