package com.snsoft.ensview {
	import com.snsoft.mapview.dataObj.MapPathSection;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.netPathfinding.NetNode;
	import com.snsoft.util.netPathfinding.NetPathfinding;

	import flash.geom.Point;

	public class MapPathManager {

		private var sections:Vector.<MapPathSection>;

		private var netPathfinding:NetPathfinding;

		private var mapAreaNodeHV:HashVector = new HashVector();

		private var pointNodeHV:HashVector = new HashVector();

		public function MapPathManager(sections:Vector.<MapPathSection>) {
			this.sections = sections;
			init();
		}

		public function findNodeByAreaName(areaName:String):NetNode {
			return mapAreaNodeHV.findByName(areaName) as NetNode;
		}

		public function findNodeByPosition(point:Point):NetNode {
			return pointNodeHV.findByName(pointName(point)) as NetNode;
		}

		public function findPath(fromNode:NetNode, toNode:NetNode):Vector.<Point> {
			return netPathfinding.finding(fromNode, toNode);
		}

		private function init():void {

			var sections:Vector.<MapPathSection> = this.sections;

			var netNode:NetNode = null;
			for (var i:int = 0; i < sections.length; i++) {
				var section:MapPathSection = sections[i];

				var sign:Boolean = false;

				var from:Point = section.from;
				var fromName:String = pointName(from);
				var fromNode:NetNode = pointNodeHV.findByName(fromName) as NetNode;
				if (fromNode == null) {
					fromNode = new NetNode(from.x, from.y);
					pointNodeHV.push(fromNode, fromName);
				}
				else {
					sign = true;
				}

				var to:Point = section.to;
				var toName:String = pointName(to);
				var toNode:NetNode = pointNodeHV.findByName(toName) as NetNode;
				if (toNode == null) {
					toNode = new NetNode(to.x, to.y);
					pointNodeHV.push(toNode, toName);
				}
				else {
					sign = true;
				}

				fromNode.addLinkNode(toNode);

				var areaName:String = section.areaName;
				if (areaName != null) {
					mapAreaNodeHV.push(toNode, areaName);
				}

				if (i == 0) {
					netNode = fromNode;
				}
			}

			for (var j:int = 0; j < pointNodeHV.length; j++) {
				var node:NetNode = pointNodeHV.findByIndex(j) as NetNode;
			}

			netPathfinding = new NetPathfinding(netNode);
		}

		private function pointName(point:Point):String {
			return point.toString();
		}
	}
}
