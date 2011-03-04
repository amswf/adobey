package ascb.play {

  import ascb.util.NumberUtilities;
  import ascb.util.ArrayUtilities;

  public class Cards {

    private var _cdkDeck:CardDeck;

    // The Cards constructor creates a deck of cards.
    public function Cards() {
      _cdkDeck = new CardDeck();
    }

    // The deal() method needs to know the number of players in the game 
    // and the number of cards to deal per player. If the cardsPerPlayer 
    // parameter is undefined, then it deals all the cards.
    public function deal(nPlayers:Number, nPerPlayer:Number = -1):Array {

      _cdkDeck.reset();
      _cdkDeck.shuffle();

      // Create an array, players, that holds the cards dealt to each player.
      var aHands:Array = new Array();

      // If a cardsPerPlayer value was passed in, deal that number of cards.
      // Otherwise, divide the number of cards (52) by the number of players.
      var nCardsEach:Number = (nPerPlayer == -1) ? Math.floor(_cdkDeck.deck.length / nPlayers) : nPerPlayer;

      // Deal out the specified number of cards to each player.
      for (var i:int = 0; i < nPlayers; i++) {

        aHands.push(new CardHand(_cdkDeck));

        // Deal a random card to each player. Remove that card from the 
        // tempCards array so that it cannot be dealt again.
        for (var j:Number = 0; j < nCardsEach; j++) {
          aHands[i].hand.push(_cdkDeck.deck.shift());
        }

        // Use Cards.orderHand() to sort a player's hand, and use setHand() 
        // to assign it to the card player object.
        aHands[i].orderHand();
      }

      // Return the players array.
      return aHands;
    }
  }
  
  
  
  
  
}