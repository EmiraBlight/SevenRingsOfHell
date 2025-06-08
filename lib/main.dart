
import 'package:flutter/material.dart';
import 'package:strip_blackjack/blackjack_app.dart';
import 'package:strip_blackjack/cookie_clicker.dart';
import 'package:flutter/services.dart';
enum GameScreen { blackjack, cookieClicker }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const GameHub(),
    );
  }
}

class GameHub extends StatefulWidget {
  const GameHub({super.key});

  @override
  State<GameHub> createState() => _GameHubState();
}

class _GameHubState extends State<GameHub> {
  GameScreen _currentScreen = GameScreen.blackjack;

  Widget _buildCurrentGame() {
    switch (_currentScreen) {
      case GameScreen.blackjack:
        return const BlackjackApp(); // your main blackjack widget
      case GameScreen.cookieClicker:
        return const CookieClicker();
      default:
        return const Center(child: Text("Unknown Game"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    
     Scaffold(
      
      body: _buildCurrentGame(),
      appBar: AppBar(
        
        
  title: const Text(''),
  foregroundColor: Colors.black54,
  backgroundColor: const Color.fromRGBO(19, 18, 20, 1),
),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.casino),
              title: const Text('Blackjack'),
              onTap: () {
                Navigator.pop(context); // close drawer
                setState(() => _currentScreen = GameScreen.blackjack);
              },
            ),
            ListTile(
              enabled : false,
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: const Icon(Icons.cookie),
              title: const Text('Cookie Clicker'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentScreen = GameScreen.cookieClicker);
              },
            ),
            //removed exit option. Did not work on windows, exit button works just fine :D
          ],
        ),
      ),
    );
  }
}

