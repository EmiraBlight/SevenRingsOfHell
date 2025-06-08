import "dart:math";

class PlayingCard {
  int number;
  String suit;
  PlayingCard(this.number, this.suit);

  bool isAce() {
    return (number == 11);
  }

  int getNumber() {
    if (number <= 11) {
      return number;
    } else {
      return 10; //if its not 1-10 or 11 (ace) return 10 its a face card
    }
  }

  String getFace() {
    if (number <= 10) {
      return number.toString();
    }
    if (number == 11) {
      return "A";
    }
    if (number == 12) {
      return "J";
    }
    if (number == 13) {
      return "Q";
    } else {
      return "K";
    }
  }
}

class Deck {
  List<PlayingCard> cards = [];

  Deck() {
    resetDeck();
  }

  PlayingCard drawCard() {
    final Random rand = Random();
    return cards.removeAt(rand.nextInt(cards.length));
  }

  void resetDeck() {
    var faces = {"Hearts", "Diamonds", "Spades", "Clubs"};
    for (int i = 0; i < 4; i++) {
      for (int j = 1; j < 14; j++) {
        // 11 == ace, 12==J, 13==Q, 14==K
        cards.add(PlayingCard(j + 1, faces.elementAt(i)));
      }
    }
  }
}

class Hand {
  List<PlayingCard> cards = [];
  int score = 0;

  Hand(Deck deck) {
    cards.add(deck.drawCard());
    cards.add(deck.drawCard());
  }

  void drawCard(Deck deck) {
    cards.add(deck.drawCard());
  }

  int getScore() {
    int scoreTally = 0;
    cards.sort((a, b) => a.getNumber() - b.getNumber());
    for (PlayingCard card in cards) {
      if (card.getNumber() == 11 && scoreTally >= 11) {
        scoreTally += 1;
      } else {
        scoreTally += card.getNumber();
      }
    }
    return scoreTally;
  }

  String displayHand() {
    String returnValue = "";
    for (PlayingCard card in cards) {
      returnValue += card.getNumber().toString();
      returnValue += " ";
    }
    return returnValue;
  }
}

class Game {
  Deck deck = Deck();
  late Hand dealer;
  late Hand player;

  Game() {
    dealer = Hand(deck);
    player = Hand(deck);
  }

  int dealerPlay() {
    while (dealer.getScore() < 16) {
      dealer.drawCard(deck);
    }
    return dealer.getScore();
  }

  void playerHit() {
    player.drawCard(deck);
  }

  bool gameOver() {
    int dealerScore = dealerPlay();
    int playerScore = player.getScore();
    deck.resetDeck();
    if (playerScore > 21) {
      return false;
    }
    if (dealerScore > 21) {
      return true;
    } //handle busts
    if (playerScore <= dealerScore) {
      return false;
    } else {
      return true;
    }
  }
}
