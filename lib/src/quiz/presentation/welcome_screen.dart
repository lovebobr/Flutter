import 'package:flutter/material.dart';

import '../../shared/widgets/level_path_page.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _scaleStart = 1.0;
  double _scaleShop = 1.0;
  double _scaleExit = 1.0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
          children: [
          // Фоновое изображение
          Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/begin.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Маленькие лого
        Positioned(
          top: screenSize.height * 0.32,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(
              'assets/ui/neo.png',
              width: screenSize.width * 0.1,
            ),
          ),
        ),
        Positioned(
          top: screenSize.height * 0.32,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              'assets/ui/neo.png',
              width: screenSize.width * 0.1,
            ),
          ),
        ),

        Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Заголовок
              Image.asset(
              'assets/ui/head.png',
              width: screenSize.width * 0.7,
            ),

            Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.09,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/ui/who.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                SizedBox(height: screenSize.height * 0.015),

                GestureDetector(
                  onTapDown: (_) => setState(() => _scaleStart = 0.9),
                  onTapUp: (_) {
                    setState(() => _scaleStart = 1.0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LevelPathScreen()),
                    );
                  },
                  onTapCancel: () => setState(() => _scaleStart = 1.0),
                  child: AnimatedScale(
                    duration: Duration(milliseconds: 100),
                    scale: _scaleStart,
                    child: Image.asset(
                      'assets/ui/play.png',
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                ),

                SizedBox(height: screenSize.height * 0.015),

                GestureDetector(
                onTapDown: (_) => setState(() => _scaleShop = 0.9),
    onTapUp: (_) => setState(() => _scaleShop = 1.0),
    onTapCancel: () => setState(() => _scaleShop = 1.0),
                  child: AnimatedScale(
                    duration: Duration(milliseconds: 100),
                    scale: _scaleShop,
                    child: Image.asset(
                      'assets/ui/shop.png',
                      width: 160,
                      height: 60,
                    ),
                  ),
                ),

                      SizedBox(height: screenSize.height * 0.015),

                      // Кнопка "Выход"
                      GestureDetector(
                        onTapDown: (_) => setState(() => _scaleExit = 0.9),
                        onTapUp: (_) => setState(() => _scaleExit = 1.0),
                        onTapCancel: () => setState(() => _scaleExit = 1.0),
                        child: AnimatedScale(
                          duration: Duration(milliseconds: 100),
                          scale: _scaleExit,
                          child: Image.asset(
                            'assets/ui/exit.png',
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ),
                      ),


                    ],
                ),
            ),
              ],
            ),
        ),
          ],
        ),
    );
  }
}