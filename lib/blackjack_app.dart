

import 'package:flutter/material.dart';
import 'package:strip_blackjack/blackjack.dart';
import 'package:strip_blackjack/main.dart';

class BlackjackApp extends StatelessWidget {
  const BlackjackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const BlackjackHomePage(),
    );
  }
}
class BlackjackHomePage extends StatefulWidget {
  const BlackjackHomePage({super.key});

  @override
  State<BlackjackHomePage> createState() => _BlackjackHomePageState();
}

class _BlackjackHomePageState extends State<BlackjackHomePage> {
  late Game game;
  String resultMessage = '';
  bool showDealer = true;
  int balance = 1000;
  int currentBet = 100;
  int dealerBalance = 1000;
  bool inRound = false;
  String player = 'var';

  @override
  void initState() {
    super.initState();
    game = Game();
  }

  String getDealerImage() {
    if (dealerBalance >= 1000) {
      return 'assets/$player/Happy.png';
    } else if (dealerBalance >= 500) {
      return 'assets/$player/worried.png';
    } else if (dealerBalance >= 100) {
      return 'assets/$player/scared.png';
    } else if (dealerBalance > 0) {
      return 'assets/$player/broke.png';
    } else {
      return 'assets/$player/winner.png';
    }
  }

  Widget hiddenCardPlaceholder() {
    return Container(
      width: 50,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[400],
        border: Border.all(color: Colors.black),
      ),
      child: const Center(
        child: Text("?", style: TextStyle(fontSize: 24, color: Colors.black)),
      ),
    );
  }

  void hit() {
    setState(() {
      inRound = false;
      game.playerHit();
      if (game.player.getScore() > 21) {
        showDealer = true;
        resultMessage = "You busted! Dealer wins.";
        balance -= currentBet;
        dealerBalance += currentBet;
      }
    });
  }

  void stand() {
    setState(() {
      inRound = false;
      showDealer = true;
      bool playerWon = game.gameOver();

      if (playerWon) {
        balance += currentBet;
        dealerBalance -= currentBet;
        resultMessage = "You win!";
      } else {
        balance -= currentBet;
        dealerBalance += currentBet;
        resultMessage = "You lose!";
      }
    });

    if (balance <= 0) {
      _showGameOverDialog();
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: const Text(
            "You have run out of money. The game will reset to starting values",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); 
                balance = 1000;
                dealerBalance = 5000;
                currentBet = 100;
                resetGame();
                inRound = false;
              },
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      if (currentBet > balance) {
        currentBet = balance;
      }
      inRound = true;
      game = Game();
      showDealer = false;
      resultMessage = '';
    });
  }

  Widget buildHand(String title, Hand hand, {bool reveal = true}) {
    List<PlayingCard> cardsToShow = reveal ? hand.cards : [hand.cards.first];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...cardsToShow.map((card) => CardWidget(card: card)),
        if (!reveal && hand.cards.length >= 2) hiddenCardPlaceholder(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Blackjack'),
  ),
  
  body: Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    buildHand("Dealer", game.dealer, reveal: showDealer),
                    Text(
                      "Dealer Balance: \$$dealerBalance",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 100, color: Colors.transparent),
                    buildHand("Player", game.player),
                    Text(
                      "Balance: \$$balance",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    if (resultMessage.isEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: hit,
                            child: const Text("Hit"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: stand,
                            child: const Text("Stand"),
                          ),
                        ],
                      )
                    else ...[
                      Text(resultMessage, style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: resetGame,
                        child: const Text("Play Again"),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bet: \$$currentBet",
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Text('- \$50'),
                          onPressed: inRound
                              ? null
                              : () {
                                  setState(() {
                                    if (currentBet > 50) currentBet -= 50;
                                  });
                                },
                        ),
                        IconButton(
                          icon: const Text('+ \$50'),
                          onPressed: inRound || currentBet + 50 > balance
                              ? null
                              : () {
                                  setState(() {
                                    currentBet += 50;
                                  });
                                },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      
                        TextButton(
                          onPressed: () {
                            balance = 1000;
                            dealerBalance = 5000;
                            player = "var";
                            resetGame();
                          },
                          child: const Text("Varoskia"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Image.asset(
                getDealerImage(),
                width: 400,
                height: 600,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final PlayingCard card;

  const CardWidget({super.key, required this.card});

  String getSuitSymbol(String suit) {
    switch (suit) {
      case 'Hearts':
        return '♥';
      case 'Diamonds':
        return '♦';
      case 'Spades':
        return '♠';
      case 'Clubs':
        return '♣';
      default:
        return '?';
    }
  }

  Color getSuitColor(String suit) {
    return (suit == 'Hearts' || suit == 'Diamonds') ? Colors.red : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final suit = getSuitSymbol(card.suit);
    final face = card.getFace();

    return Container(
      width: 50,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Center(
        child: Text(
          "$face$suit",
          style: TextStyle(
            fontSize: 24,
            color: getSuitColor(card.suit),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
