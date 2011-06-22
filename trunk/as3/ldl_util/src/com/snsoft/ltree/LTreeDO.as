package com.snsoft.ltree {
	import com.snsoft.util.rlm.rs.RSImages;
	import com.snsoft.util.xmldom.NodeList;

	/**
	 * 树公共数据对象
	 * @author Administrator
	 *
	 */
	public class LTreeDO {

		private var _rsImages:RSImages;

		private var _nodeList:NodeList;

		private var _lTreeCommonSkin:LTreeCommonSkin;

		public function LTreeDO() {

		}

		public function get rsImages():RSImages {
			return _rsImages;
		}

		public function set rsImages(value:RSImages):void {
			_rsImages = value;
		}

		public function get nodeList():NodeList {
			return _nodeList;
		}

		public function set nodeList(value:NodeList):void {
			_nodeList = value;
		}

		public function get lTreeCommonSkin():LTreeCommonSkin
		{
			return _lTreeCommonSkin;
		}

		public function set lTreeCommonSkin(value:LTreeCommonSkin):void
		{
			_lTreeCommonSkin = value;
		}


	}
}
