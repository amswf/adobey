package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.snsoft.xml.*;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;

	public class RootBtnMc extends MovieClip
	{
		private var xlp:XMLLoadParse = null;

		private var textArray:Array = new Array();
		
		private var urlArray:Array = new Array();
		
		private var rooturl:String = null;
		
		private var sl:MovieClip = null;
		
		private var _xmlUrl:String;
		
		public function set xmlUrl(url:String):void{
			trace(url);
			_xmlUrl = url;
		}
		public function get xmlUrl():String{
			return _xmlUrl;
		}
		
		public function RootBtnMc()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		private function handlerEnterFrame(e:Event):void{
			if(xmlUrl != null){
				this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
				xlp = new XMLLoadParse(xmlUrl);
				xlp.addEventListener(Event.COMPLETE,completHandler);
				xlp.parse();
			}
		}
		
		private function completHandler(me:Event):void {
			trace("completHandler");
			if (xlp != null) {
				var rs:RecordSet = xlp.getRecordSet();
				if (rs != null) {
					trace("rs.length" + rs.size());
					sl = new SelectList();
					for (var i:int=0; i<rs.size(); i++) {
						var rd:Record = rs.getBy(i);
						if(rd.getValue("rooturl") != null && rd.getValue("rooturl").length > 0){
							rooturl = rd.getValue("rooturl");
						}
						if (rd.getValue("rootx") != null) {
							var rootx:Number = Number(rd.getValue("rootx"));
							sl.x = rootx;
						}
						if (rd.getValue("rooty") != null) {
							var rooty:Number = Number(rd.getValue("rooty"));
							sl.y = rooty;
						}
						var childtext:String = rd.getValue("childtext");
						textArray.push(childtext);
						var childurl:String = rd.getValue("childurl");
						urlArray.push(childurl);
					}
					var mc = this.mcMC;
					if(mc != null){
						mc.addEventListener(MouseEvent.CLICK,handlerMouseClick);
						mc.addEventListener(MouseEvent.MOUSE_OVER,handlerMcMouseOver);
						this.addEventListener(MouseEvent.MOUSE_OUT,handlerMcMouseOut);
						sl.addEventListener(MouseEvent.MOUSE_OVER,handlerSelectListMouseOver);
					}
					sl.visible = false;
					sl.vTextArray = textArray;
					sl.vUrlArray = urlArray;
					sl.visibleNum = 4;
					sl.listType = true;
					this.addChild(sl);
				}
			}
		}
		
		
		private function handlerSelectListMouseOver(e:Event):void{
			trace("handlerSelectListMouseOver");
		}
		
		private function handlerMcMouseOver(e:Event):void{
			try{
			gotoAndStop(2);
			}
			catch(e:Error){
			}
		}
		
		
		
		private function handlerMcMouseOut(e:Event):void{
			trace("handlerMcMouseOut");
			try{
			gotoAndStop(3);
			}
			catch(e:Error){
			}
			if(sl != null){
				sl.visible = false;
			}
		}
		
		
		private function handlerMouseClick(me:MouseEvent):void {
			trace("handlerMouseClick");
			try{
			gotoAndStop(3);
			}
			catch(e:Error){
			}
			if (rooturl != null) {
				var requests:URLRequest = new URLRequest(rooturl);
				var values:URLVariables = new URLVariables();
				var date:Date = new Date();
				date.getTime();
				values.randomNum = String(date.getTime());
				requests.data = values;
				requests.method = "GET";
				navigateToURL(requests,"_blank");
			}
			else {
				if(sl != null){
					sl.visible = true;
				}
			}
		}
	}
}