import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/quiz/presentation/welcome_screen.dart'; // <-- путь до твоего WelcomeScreen
import 'monet_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MonetProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
