import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../quiz/domain/_domain.dart';

class NeonchikQuizHeader extends StatefulWidget {
  const NeonchikQuizHeader({
    required this.title,
    required this.answers,
    this.timeToShowAnswer = const Duration(seconds: 3),
    super.key,
  });

  final String title;
  final List<QuizDTOAnswer> answers;
  final Duration timeToShowAnswer;

  @override
  State<NeonchikQuizHeader> createState() => _NeonchikQuizHeaderState();
}

class _NeonchikQuizHeaderState extends State<NeonchikQuizHeader> {
  final key = GlobalKey();

  double textHeight = 0;

  @override
  void initState() {
    // Вызываем getHeight после рендеринга
    WidgetsBinding.instance.addPostFrameCallback((_) => getHeight());
    super.initState();
  }

  void getHeight() {
    final State? state = key.currentState;
    final BuildContext? context = key.currentContext;
    textHeight = context?.size?.height ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.viewPaddingOf(context).top,
          16,
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: key,
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms) // Анимация без задержки
                .moveY(begin: 30, end: 0, duration: 600.ms), // Плавное движение вверх

            SizedBox(
              width: double.infinity,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 3,
                children: widget.answers.mapIndexed(
                      (i, e) {
                    return Text(
                      '${e.code}. ${e.title}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                        .animate()
                        .then(
                      delay: 0.ms + (i * 600).ms, // Уменьшена задержка между ответами
                    )
                        .fadeIn(duration: 600.ms) // Уменьшена продолжительность анимации
                        .moveY(begin: 30, end: 0, duration: 600.ms); // Плавный подъем
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
