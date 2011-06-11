package com.snsoft.effect {
	import com.snsoft.fmc.test.vi.PubNetStream;

	import flash.geom.Point;

	public class Ellipse {

		private var x0:int;
		private var y0:int;
		private var a:int;
		private var b:int;

		public function Ellipse(x0:Number, y0:Number, a:Number, b:Number) {
			this.x0 = x0;
			this.y0 = y0;
			this.a = a;
			this.b = b;

			midpointellipse();
		}

		public function getPoints():Vector.<Point> {
			var list:Vector.<Point> = new Vector.<Point>();
			var plist:Vector.<Point> = midpointellipse();
			pushList1(list, plist);
			pushList2(list, plist);
			pushList3(list, plist);
			pushList4(list, plist);
			return list;
		}

		public function midpointellipse():Vector.<Point> {
			var plist:Vector.<Point> = new Vector.<Point>();

			var x:int = 0;
			var y:int = 0;
			var d:int = 0;
			var sa:Number = 0;
			var sb:Number = 0;
			var xp:int = 0;
			var yp:int = 0;

			sa = a * a, sb = b * b;
			xp = int(sa / Math.sqrt(sa + sb));
			yp = int(sb / Math.sqrt(sa + sb));

			x = 0, y = b, d = sa + 4 * sb - 4 * sa * b;

			while (x < xp) {
				if (d < 0) {
					d = d + 4 * sb * (2 * x + 3);
					x++;
				}
				else {
					d = d + 4 * sb * (2 * x + 3) + 4 * sa * (2 - 2 * y);
					x++;
					y--;
				}
				plist.push(new Point(x, y));
			}

			x = a, y = 0, d = 4 * sa + sb - 4 * a * sb;
			var list:Vector.<Point> = new Vector.<Point>();
			while (y < yp) {
				if (d < 0) {
					d = d + 4 * sa * (2 * y + 3);
					y++;
				}
				else {
					d = d + 4 * sa * (2 * y + 3) + 4 * sb * (2 - 2 * x);
					y++;
					x--;
				}
				list.push(new Point(x, y));
			}

			for (var i:int = list.length - 1; i >= 0; i--) {
				var pp:Point = list[i];
				var p:Point = new Point(pp.x, pp.y);
				plist.push(p);
			}

			return plist;
		}

		private function pushList1(list:Vector.<Point>, plist:Vector.<Point>):void {
			list.push(new Point(x0, b + y0));
			for (var i:int = 0; i < plist.length; i++) {
				var pp:Point = plist[i];
				var p:Point = new Point(pp.x + x0, pp.y + y0);
				list.push(p);
			}
		}

		private function pushList2(list:Vector.<Point>, plist:Vector.<Point>):void {
			list.push(new Point(a + x0, y0));
			for (var i:int = plist.length - 1; i >= 0; i--) {
				var pp:Point = plist[i];
				var p:Point = new Point(pp.x + x0, -pp.y + y0);
				list.push(p);
			}
		}

		private function pushList3(list:Vector.<Point>, plist:Vector.<Point>):void {
			list.push(new Point(x0, -b + y0));
			for (var i:int = 0; i < plist.length; i++) {
				var pp:Point = plist[i];
				var p:Point = new Point(-pp.x + x0, -pp.y + y0);
				list.push(p);
			}
		}

		private function pushList4(list:Vector.<Point>, plist:Vector.<Point>):void {
			list.push(new Point(-a + x0, y0));
			for (var i:int = plist.length - 1; i >= 0; i--) {
				var pp:Point = plist[i];
				var p:Point = new Point(-pp.x + x0, pp.y + y0);
				list.push(p);
			}
		}
	}
}
