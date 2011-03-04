package ascb.play{
	public class CardHand {
		
		private var _cdkDeck:CardDeck;
		private var _aHand:Array;
		
		public function get hand():Array {
			return _aHand;
		}
		
		public function get length():int {
			return _aHand.length;
		}
		
		// When a new card player is created by way of its constructor, pass it
		// a reference to the card deck, and give it a unique player ID.
		public function CardHand(cdkDeck:CardDeck) {
			_aHand = new Array();
			_cdkDeck = cdkDeck;
		}
		
		public function getCardAt(nIndex:int):Card {
			return _aHand[nIndex];
		}
		
		
		public function discard():Array {
			var aCards:Array = new Array();
			for(var i:Number = 0; i < arguments.length; i++) {
				aCards.push(_aHand[arguments[i]]);
				_cdkDeck.push(_aHand[arguments[i]]);
			}
			for(var ii:Number = 0; ii < arguments.length; ii++) {
				_aHand.splice(arguments[ii], 1);
			}
			return aCards;
		}
		
		public function draw(nDraw:Number = 1):void {
			
			// Add the specified number of cards to the hand.
			for (var i:int = 0; i < nDraw; i++) {
				_aHand.push(_cdkDeck.deck.shift());
			}
			
			orderHand();
		}
		
		public function orderHand():void {
			_aHand.sort(sorter);
		}
		
		// Used by sort() in the orderHand() method to sort the cards by suit and rank.
		private function sorter(crdA:Card, crdB:Card):Number {
			if (crdA.suit > crdB.suit) {
				return 1;
			} else if (crdA.suit < crdB.suit) {
				return -1;
			} else {
				return (Number(crdA.value) > Number(crdB.value)) ? 1 : 0;
			}
		}
		
	}
}