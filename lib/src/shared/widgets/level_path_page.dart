import 'package:flutter/material.dart';
import 'package:neoflex/animations/robot_movement.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../quiz/presentation/game_screen.dart';
import '../../quiz/presentation/question_screen.dart';


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
  bool? _robotControllerIsReady;
  double _scaleGameButton = 1.0;
  double _scaleInfoButton = 1.0;

  @override
  void dispose() {
    _robotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;

    _points = List.generate(9, (index) {
      double dy = height * 0.85 - index * height * 0.09;
      double dx = (index % 2 == 0) ? width * 0.3 : width * 0.7;
      return Offset(dx, dy);
    });

    if (!(_robotControllerIsReady ?? false)) {
      _robotController = RobotMovementController(
        points: _points,
        vsync: this,
        onUpdate: () {
          setState(() {
            _robotPosition = _robotController.currentRobotPosition;
          });
        },
      );
      _robotPosition = _points[0];
      _robotControllerIsReady = true;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/begin.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
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
              top: 70,
              right: 25,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _scaleGameButton = 0.9),
                onTapUp: (_) async {
                  setState(() => _scaleGameButton = 1.0);
                  await Future.delayed(Duration(milliseconds: 100));
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MemoryGameScreen()),
                  );
                },

                onTapCancel: () => setState(() => _scaleGameButton = 1.0),
                child: AnimatedScale(
                  scale: _scaleGameButton,
                  duration: Duration(milliseconds: 100),
                  child: Image.asset(
                    'assets/images/game.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 2,
              right: 20,
              child: GestureDetector(
                onTapDown: (_) => setState(() => _scaleInfoButton = 0.9),
                onTapUp: (_) async {
                  setState(() => _scaleInfoButton = 1.0);
                  await Future.delayed(Duration(milliseconds: 100)); // Задержка перед показом диалога
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Информация'),
                      content: Text('Это экран уровней!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                onTapCancel: () => setState(() => _scaleInfoButton = 1.0),
                child: AnimatedScale(
                  scale: _scaleInfoButton,
                  duration: Duration(milliseconds: 100),
                  child: Image.asset(
                    'assets/ui/i.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),


            CustomPaint(
              size: Size(width, height),
              painter: PathPainter(_points),
            ),

            ..._points.asMap().entries.map((entry) {
              int index = entry.key;
              Offset point = entry.value;
              bool isTapped = _tappedIndex == index;

              return Positioned(
                left: point.dx - width * (isTapped ? 0.08 : 0.06),
                top: point.dy - width * (isTapped ? 0.08 : 0.06),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _tappedIndex = index;
                    });
                    _robotController.moveTo(index, 800);
                    _robotController.addOnCompleteListener(() async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuestionScreen(
                            questionIndex: index,
                          ),
                        ),
                      );

                      if (result == false && _lives > 0) {
                        setState(() {
                          _lives--;
                        });
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: width * (isTapped ? 0.16 : 0.12),
                    height: width * (isTapped ? 0.16 : 0.12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF8B5BFF),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.045,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),

            // Робот
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
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
