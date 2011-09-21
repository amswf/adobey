package com.snsoft.tsp3.test {
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;

	/**
	 * 动态创建皮肤 
	 * @author Administrator
	 * 
	 */	
	public class Skins {

		private static var domain:ApplicationDomain;

		public function Skins() {
		}

		public static function setDomain(domain:ApplicationDomain):void {
			Skins.domain = domain;
		}

		public static function getSkin(skinName:String):MovieClip {
			return SkinsUtil.createSkinByName(skinName, domain);
		}
	}
}
