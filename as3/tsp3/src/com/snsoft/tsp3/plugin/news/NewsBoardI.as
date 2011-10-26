package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SpriteUtil;
	
	import flash.geom.Point;

	/**
	 * 不带图片
	 * @author Administrator
	 *
	 */
	public class NewsBoardI extends NewsBoardBase {

		private var hMax:int = 100;

		public function NewsBoardI(infoSize:Point, data:DataDTO) {
			this.infoSize = infoSize;
			this._data = data;
			super();
		}

		override protected function configMS():void {
			this.addChild(titleLayer);
			this.addChild(scrollLayer);
			this.addChild(maskLayer);
		}

		override protected function draw():void {
			ctntWidth = infoSize.x - boader - boader;
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			SpriteUtil.deleteAllChild(titleLayer);
			SpriteUtil.deleteAllChild(scrollLayer);
			SpriteUtil.deleteAllChild(maskLayer);

			//基础信息，标题，日期，关键词
			addBaseItems(ndp);
			//附件、图片、音乐、影片
			addSrcs(data);
			//其它数据项输出
			addExpItems(ndp);
			//内容单独输出，并且在最后
			addDigest(ndp);
		}

	}
}
