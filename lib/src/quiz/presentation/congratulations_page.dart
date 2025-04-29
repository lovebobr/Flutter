import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Если у вас используется Lottie для анимаций
import 'package:provider/provider.dart';
import 'welcome_screen.dart'; // Импортируем экран приветствия

class CongratulationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поздравляем!'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animations/fireworks.json'),
            const Text(
              'Вы прошли все уровни!\nПоздравляем с победой!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
