package soil {
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.UUID;
	import com.snsoft.util.xmldom.Node;
	import com.snsoft.util.xmldom.NodeList;
	import com.snsoft.util.xmldom.XMLConfig;
	import com.snsoft.util.xmldom.XMLDom;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class Soil extends Sprite {

		private var cfg:XMLConfig = new XMLConfig();

		private var tab1:Sprite = new Sprite();

		private var tab2:Sprite = new Sprite();

		private var timer:Timer;

		private var lock:Boolean = false;

		public function Soil() {
			super();
			tab1.x = 30;
			tab1.y = 140;
			this.addChild(tab1);

			tab2.x = 30;
			tab2.y = 350;
			this.addChild(tab2);
			init();
		}

		private function init():void {
			cfg.load("config.xml");
			cfg.addEventListener(Event.COMPLETE, handlerLoadCmp);
		}

		private function handlerLoadCmp(e:Event):void {
			timer = new Timer(Number(cfg.getConfig("delay")), 0);
			timer.addEventListener(TimerEvent.TIMER, handlerTimer);
			timer.start();
		}

		private function handlerTimer(e:Event):void {
			if (!lock) {
				lock = true;
				var uuid:String = "";
				//uuid = "&random=" + UUID.create();

				var ul:URLLoader = new URLLoader(new URLRequest(cfg.getConfig("url") + uuid));
				ul.addEventListener(Event.COMPLETE, handlerDataCmp);
			}
		}

		private function handlerDataCmp(e:Event):void {

			var ul:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(ul.data);
			refreshTab(xml);
			refreshDate();
			lock = false;
		}

		private function refreshTab(xml:XML):void {

			var dom:XMLDom = new XMLDom(xml);
			var xmlNode:Node = dom.parse();

			var recordList:NodeList = xmlNode.getNodeList("record");

			var vstem1:Vector.<Number> = new Vector.<Number>();
			var vstem2:Vector.<Number> = new Vector.<Number>();
			var vssoilTem0:Vector.<Number> = new Vector.<Number>();
			var vssoilTem10:Vector.<Number> = new Vector.<Number>();
			var vssoilTem20:Vector.<Number> = new Vector.<Number>();
			var vshumidity:Vector.<Number> = new Vector.<Number>();
			var vsco2:Vector.<Number> = new Vector.<Number>();
			var vslightRadio:Vector.<Number> = new Vector.<Number>();
			var vstotalRadio:Vector.<Number> = new Vector.<Number>();

			for (var i:int = 0; i < recordList.length(); i++) {
				var recordNode:Node = recordList.getNode(i);
				vstem1.push(Number(recordNode.getAttributeByName("tem1")));
				vstem2.push(Number(recordNode.getAttributeByName("tem2")));
				vssoilTem0.push(Number(recordNode.getAttributeByName("soilTem0")));
				vssoilTem10.push(Number(recordNode.getAttributeByName("soilTem10")));
				vssoilTem20.push(Number(recordNode.getAttributeByName("soilTem20")));
				vshumidity.push(Number(recordNode.getAttributeByName("hum")));
				vsco2.push(Number(recordNode.getAttributeByName("co2")));
				vslightRadio.push(Number(recordNode.getAttributeByName("lightRadio")));
				vstotalRadio.push(Number(recordNode.getAttributeByName("totalRadio")));
			}

			if (recordList.length() > 0) {
				var lNode:Node = recordList.getNode(recordList.length() - 1);
				for (var j:int = 0; j < lNode.attributeLen(); j++) {
					var aname:String = lNode.getAttributeNameByIndex(j);
					trace(aname);
					var tfd:TextField = this.getChildByName(aname) as TextField;
					tfd.text = lNode.getAttributeByIndex(j);
				}

			}

			var fltem1:FoldLine = new FoldLine(0xff0000, 500, 200, Number(cfg.getConfig("temperatureMin")), Number(cfg.getConfig("temperatureMax")), vstem1);

			var fltem2:FoldLine = new FoldLine(0x00ff00, 500, 200, Number(cfg.getConfig("temperatureMin")), Number(cfg.getConfig("temperatureMax")), vstem2);

			var flsoilTem0:FoldLine = new FoldLine(0x0000ff, 500, 200, Number(cfg.getConfig("soilTemMin")), Number(cfg.getConfig("soilTemMax")), vssoilTem0);

			var flsoilTem10:FoldLine = new FoldLine(0x000000, 500, 200, Number(cfg.getConfig("soilTemMin")), Number(cfg.getConfig("soilTemMax")), vssoilTem10);

			var flsoilTem20:FoldLine = new FoldLine(0x00ffff, 500, 200, Number(cfg.getConfig("soilTemMin")), Number(cfg.getConfig("soilTemMax")), vssoilTem20);

			var flhumidity:FoldLine = new FoldLine(0xff0000, 500, 200, Number(cfg.getConfig("humidityMin")), Number(cfg.getConfig("humidityMax")), vshumidity);

			var flco2:FoldLine = new FoldLine(0x00ff00, 500, 200, Number(cfg.getConfig("co2Min")), Number(cfg.getConfig("co2Max")), vsco2);

			var fllightRadio:FoldLine = new FoldLine(0x0000ff, 500, 200, Number(cfg.getConfig("radioMin")), Number(cfg.getConfig("radioMax")), vslightRadio);

			var fltotalRadio:FoldLine = new FoldLine(0x000000, 500, 200, Number(cfg.getConfig("radioMin")), Number(cfg.getConfig("radioMax")), vstotalRadio);

			SpriteUtil.deleteAllChild(tab1);
			SpriteUtil.deleteAllChild(tab2);

			tab1.addChild(fltem1);
			tab1.addChild(fltem2);
			tab1.addChild(flsoilTem0);
			tab1.addChild(flsoilTem10);
			tab1.addChild(flsoilTem20);

			tab2.addChild(flhumidity);
			tab2.addChild(flco2);
			tab2.addChild(fllightRadio);
			tab2.addChild(fltotalRadio);
		}

		private function refreshDate():void {
			trace("asdf");
			var dateTfd:TextField = this.getChildByName("dateTfd") as TextField;
			dateTfd.text = getDate();
		}

		private function getDate():String {

			var date:Date = new Date();
			var str:String = "";
			str += (date.getFullYear() + "年");
			str += ((date.getMonth() + 1) + "月");
			str += (date.getDate() + "日");
			str += (date.getHours() + "时");
			str += (date.getMinutes() + "分");
			str += (date.getSeconds() + "秒");
			trace("getDate", date.getFullYear());
			return str;
		}
	}
}
