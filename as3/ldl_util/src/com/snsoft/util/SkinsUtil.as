package com.snsoft.util {
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	public class SkinsUtil {
		public function SkinsUtil() {
		}

		/**
		 * 通过皮肤名称动态创建皮肤对象
		 * @param skinName 皮肤名称
		 * @return
		 *
		 */
		public static function createSkinByName(skinName:String, domain:ApplicationDomain = null):MovieClip {
			var main:MovieClip = new MovieClip();
			var mc:MovieClip;
			try {

				var MClass:Class;
				if (domain == null) {
					MClass = getDefinitionByName(skinName) as Class;
				}
				else {
					MClass = domain.getDefinition(skinName) as Class;
				}
				mc = new MClass() as MovieClip;
			}
			catch (e:Error) {
				trace(" error SkinsUtil.createSkinByName() 动态加载找不到皮肤：" + skinName);
			}
			return mc;
		}
	}
}
