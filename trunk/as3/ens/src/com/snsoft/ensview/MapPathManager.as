package com.snsoft.ensview {
	import com.snsoft.mapview.dataObj.MapPathSection;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.pf.Border;
	import com.snsoft.util.pf.Pathfinder;

	import flash.geom.Point;

	public class MapPathManager {

		private var sections:Vector.<MapPathSection>;

		private var pathfinding:Pathfinder;

		private var pointHV:HashVector = new HashVector();

		private var currentPositionAreaCode:String;

		private var sectionHV:HashVector = new HashVector();

		public function MapPathManager(sections:Vector.<MapPathSection>, currentPositionAreaCode:String) {
			this.sections = sections;
			this.currentPositionAreaCode = currentPositionAreaCode;
			init();
		}

		private function init():void {

			var sections:Vector.<MapPathSection> = this.sections;
			initPointHV();
			initPathFinder();
		}

		public function findPath(areaId:String):Vector.<Point> {
			var points:Vector.<Point> = new Vector.<Point>();
			var section:MapPathSection = sectionHV.findByName(areaId) as MapPathSection;
			if (section != null) {
				var eindex:int = pointHV.findIndexByName(pointName(section.to)) as int;
				if (!isNaN(eindex)) {
					var v:Vector.<int> = pathfinding.getPath(eindex);

					if (v != null) {
						for (var i:int = 0; i < v.length; i++) {
							var index:int = v[i];
							var point:Point = pointHV.findByIndex(index) as Point;
							points.push(point);
						}
					}
				}
			}
			return points;
		}

		private function initPathFinder():void {
			var borders:Vector.<Border> = new Vector.<Border>();
			var currentPoint:Point = null;
			for (var i:int = 0; i < sections.length; i++) {
				var section:MapPathSection = sections[i];
				sectionHV.push(section, section.areaName);

				var from:Point = section.from;
				var fromIndex:int = pointHV.findIndexByName(pointName(from));

				var to:Point = section.to;
				var toIndex:int = pointHV.findIndexByName(pointName(to));

				var value:int = Point.distance(from, to);
				var border:Border = new Border(fromIndex, toIndex, value);
				borders.push(border);

				if (section.areaName == currentPositionAreaCode) {
					currentPoint = section.to;
				}
			}

			var startIndex:int = pointHV.findIndexByName(pointName(currentPoint));
			pathfinding = new Pathfinder(borders, startIndex);

		}

		private function initPointHV():void {
			for (var i:int = 0; i < sections.length; i++) {
				var section:MapPathSection = sections[i];

				var from:Point = section.from;
				pointHV.push(from, pointName(from));

				var to:Point = section.to;
				pointHV.push(to, pointName(to));
			}
		}

		private function pointName(point:Point):String {
			return point.toString();
		}
	}
}
