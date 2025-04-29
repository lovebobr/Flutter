import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:neoflex/animations/robot_movement.dart';
import '../../quiz/presentation/game_screen.dart';
import '../../quiz/presentation/question_screen.dart';
import '../../../../monet_provider.dart';
import 'package:provider/provider.dart';

import 'info_page.dart';

class LevelPathScreen extends StatefulWidget {
  @override
  _LevelPathScreenState createState() => _LevelPathScreenState();
}

class _LevelPathScreenState extends State<LevelPathScreen> with TickerProviderStateMixin {
  int? _tappedIndex;
  late List<Offset> _points;
  late RobotMovementController _robotController;
  Offset _robotPosition = Offset.zero;

  int _lives = 3;
  bool _robotControllerIsReady = false;

  double _scaleGameButton = 1.0;
  double _scaleInfoButton = 1.0;
  final Duration _buttonAnimationDuration = const Duration(milliseconds: 150);

  int _currentUnlockedLevel = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      _points = _calculatePoints(size);
      _initRobotController();
    });
  }

  List<Offset> _calculatePoints(Size size) {
    List<Offset> levelPoints = List.generate(9, (index) {
      double dy = size.height * 0.85 - index * size.height * 0.09;
      double dx = (index % 2 == 0) ? size.width * 0.3 : size.width * 0.7;
      return Offset(dx, dy);
    });

    Offset startPoint = Offset(size.width * 0.5, size.height * 0.92);

    return [startPoint, ...levelPoints];
  }

  void _initRobotController() {
    _robotController = RobotMovementController(
      points: _points,
      vsync: this,
      onUpdate: () => setState(() {
        _robotPosition = _robotController.currentRobotPosition;
      }),
    );
    _robotPosition = _points[0] - Offset(-15, 30);
    _robotControllerIsReady = true;
  }

  @override
  void dispose() {
    _robotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    if (!_robotControllerIsReady) {
      _points = _calculatePoints(size);
      _initRobotController();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Фон
          Positioned.fill(
            child: Image.asset(
              'assets/images/begin.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 5,
            left: 20,
            child: Row(
              children: List.generate(
                _lives,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Image.asset(
                    'assets/ui/heart.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 20,
            right: 20,
            child: _buildAnimatedButton(
              iconPath: 'assets/ui/i.png',
              scale: _scaleInfoButton,
              onTap: () => _navigateToInfoPage(context),
              tapDownScale: 1.2,
            ),
          ),


          Positioned(
            top: 140,  // Сдвигаем баланс немного ниже, чтобы он был под джойстиком
            right: 25,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.greenAccent, size: 24),
                  SizedBox(width: 4),
                  Text(
                    '${context.watch<MonetProvider>().wallet}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 70,
            right: 25,
            child: _buildAnimatedButton(
              iconPath: 'assets/images/game.png',
              scale: _scaleGameButton,
              onTap: () => _navigateToGameScreen(context),
              tapDownScale: 0.9,
            ),
          ),

          IgnorePointer(
            child: CustomPaint(
              size: Size(width, height),
              painter: PathPainter(_points),
            ),
          ),

          Positioned(
            left: _points[0].dx - width * 0.1,
            top: _points[0].dy - width * 0.1,
            child: Image.asset(
              'assets/images/play.png',
              width: width * 0.25,
              height: width * 0.25,
            ),
          ),

          ..._points.asMap().entries.where((entry) => entry.key != 0).map((entry) {
            int index = entry.key;
            Offset point = entry.value;
            bool isTapped = _tappedIndex == index;
            bool isLocked = index > _currentUnlockedLevel;

            return Positioned(
              left: point.dx - width * (isTapped ? 0.08 : 0.06),
              top: point.dy - width * (isTapped ? 0.08 : 0.06),
              child: GestureDetector(
                onTap: () {
                  if (!isLocked) {
                    _handleLevelTap(index);
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: _buttonAnimationDuration,
                      width: width * (isTapped ? 0.16 : 0.12),
                      height: width * (isTapped ? 0.16 : 0.12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLocked ? Colors.grey : Color(0xFF8B5BFF),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index}',
                          style: TextStyle(
                            color: isLocked ? Colors.black45 : Colors.white,
                            fontSize: width * 0.045,
                          ),
                        ),
                      ),
                    ),
                    if (isLocked)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: width * 0.05,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),

          if (_robotPosition != Offset.zero)
            Positioned(
              left: _robotPosition.dx - width * 0.08,
              top: _robotPosition.dy - width * 0.08,
              child: SvgPicture.asset(
                'assets/svg/neonchik.svg',
                width: width * 0.16,
                height: width * 0.16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton({
    required String iconPath,
    required double scale,
    required VoidCallback onTap,
    required double tapDownScale,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTapDown: (_) => setState(() {
          if (iconPath.contains('game')) {
            _scaleGameButton = tapDownScale;
          } else {
            _scaleInfoButton = tapDownScale;
          }
        }),
        onTapUp: (_) {
          setState(() {
            if (iconPath.contains('game')) {
              _scaleGameButton = 1.0;
            } else {
              _scaleInfoButton = 1.0;
            }
          });
          onTap();
        },
        onTapCancel: () => setState(() {
          if (iconPath.contains('game')) {
            _scaleGameButton = 1.0;
          } else {
            _scaleInfoButton = 1.0;
          }
        }),
        child: AnimatedScale(
          duration: _buttonAnimationDuration,
          scale: scale,
          child: Image.asset(
            iconPath,
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }

  void _handleLevelTap(int index) {
    if (index == 0) return;

    setState(() => _tappedIndex = index);
    _robotController.moveTo(index, 800);
    _robotController.addOnCompleteListener(() async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionScreen(questionIndex: index - 1),
        ),
      );

      if (result == true && mounted) {
        setState(() {
          if (_currentUnlockedLevel == index && _currentUnlockedLevel < _points.length - 1) {
            _currentUnlockedLevel++;
          }
        });
      } else if (result == false && _lives > 0 && mounted) {
        setState(() {
          _lives--;
        });

        if (_lives > 0 && _tappedIndex != 0) {
          int previousLevel = _tappedIndex! - 1;
          _robotController.moveTo(previousLevel, 800);

          setState(() {
            _tappedIndex = previousLevel;
          });
        }
      }
    });
  }

  Future<void> _navigateToGameScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MemoryGameScreen()),
    );
  }
  Future<void> _navigateToInfoPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => InfoPage()), // Переход на страницу информации
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Информация'),
        content: Text('Это экран уровней! Проходите их по порядку.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}


class PathPainter extends CustomPainter {
  final List<Offset> points;
  PathPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 8);

    Paint pathPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();

    if (points.length > 2) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = i == 0 ? points[i] : points[i - 1];
        final p1 = points[i];
        final p2 = points[i + 1];
        final p3 = (i + 2 < points.length) ? points[i + 2] : p2;

        final control1 = Offset(
          p1.dx + (p2.dx - p0.dx) / 1.5,
          p1.dy + (p2.dy - p0.dy) / 1.5,
        );

        final control2 = Offset(
          p2.dx - (p3.dx - p1.dx) / 1.5,
          p2.dy - (p3.dy - p1.dy) / 1.5,
        );

        path.cubicTo(
          control1.dx,
          control1.dy,
          control2.dx,
          control2.dy,
          p2.dx,
          p2.dy,
        );
      }
    }

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
