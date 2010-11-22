package ascb.play{
	import ascb.util.ArrayUtilities;

	public class CardDeck {
		
		private var _aCards:Array;
		
		public function get deck():Array {
			return _aCards;
		}
		
		public function CardDeck() {
			_aCards = new Array();
			reset();
		}
		
		public function reset():void {
			for(var i:Number = 0; i < _aCards.length; i++) {
				_aCards.shift();
			}
			
			// Create a local array that contains the names of the four suits.
			var aSuits:Array = ["Hearts", "Diamonds", "Spades", "Clubs"];
			
			// Specify the names of the cards for stuffing into the cards array later.
			var aCardNames:Array = ["2", "3", "4", "5", "6", "7", "8", "9", "10",
				"J", "Q", "K", "A"];
			
			// Create a 52-card array. Each element is an object that contains
			// properties for: the card's integer value (for sorting purposes), card name, 
			// suit name, and display name. The display name combines the card's name
			// and suit in a single string for display to the user.
			for (var ii:Number = 0; ii < aSuits.length; ii++) {
				// For each suit, add thirteen cards
				for (var jj:Number = 0; jj < 13; jj++) {
					_aCards.push(new Card(jj, aCardNames[jj], aSuits[jj]));
				}
			}
		}
		
		public function shuffle():void {
			var aShuffled:Array = ArrayUtilities.randomize(_aCards);
			for(var i:Number = 0; i < aShuffled.length; i++) {
				_aCards[i] = aShuffled[i];
			}
		}
		
		public function push(oParameter:Object):void {
			_aCards.push(oParameter);
		}
		
	}
}