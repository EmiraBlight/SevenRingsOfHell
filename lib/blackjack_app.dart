// ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
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
