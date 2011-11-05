package com.snsoft.tsp3.hand {

	public class HandGroup {

		private var _left:Hand;
		private var _right:Hand;
		private var _up:Hand;
		private var _down:Hand;

		public function HandGroup(handWidth:int, handHeight:int) {
			_left = new Hand(Hand.SKIN_LEFT, handWidth, handHeight);
			_right = new Hand(Hand.SKIN_RIGHT, handWidth, handHeight);
			_up = new Hand(Hand.SKIN_UP, handWidth, handHeight);
			_down = new Hand(Hand.SKIN_DOWN, handWidth, handHeight);
		}

		public function get left():Hand {
			return _left;
		}

		public function get right():Hand {
			return _right;
		}

		public function get up():Hand {
			return _up;
		}

		public function get down():Hand {
			return _down;
		}

	}
}
