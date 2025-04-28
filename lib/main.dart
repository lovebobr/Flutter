import 'package:flutter/material.dart';
import 'package:neoflex/src/quiz/presentation/welcome_screen.dart';
import 'src/shared/widgets/level_path_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

