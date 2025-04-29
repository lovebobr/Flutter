import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../quiz/domain/_domain.dart';
import 'level_path_page.dart';
import 'lottie_animation.dart';
import 'neon_anim_1.dart';
import 'neon_anim_2.dart';
import 'neon_anim_3.dart';
import 'neon_anim_4.dart';
import 'neonchik_quiz_header.dart';
import '../../../../monet_provider.dart';
import 'package:provider/provider.dart';



class NeonchikQuiz extends StatefulWidget {
  const NeonchikQuiz({
    required this.onPressed,
    required this.title,
    required this.answers,
    this.timeToShowAnswer = const Duration(seconds: 1),
    this.onEarnMoney, // <-- новое поле
    super.key,

  });

  final void Function(int value)? onEarnMoney;


  final String title;
  final List<QuizDTOAnswer> answers;
  final Future<bool> Function(String value) onPressed;
  final Duration timeToShowAnswer;

  @override
  State<NeonchikQuiz> createState() => _NeonchikQuizState();
}

class _NeonchikQuizState extends State<NeonchikQuiz> with TickerProviderStateMixin {
  late final AnimationController _controller;

  List<String> answers = const ['A', 'B', 'C', 'D'];
  Random random = Random();

  bool onPause = false;
  late Duration showAnswers;

  bool fail = false;
  bool congratulation = false;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    showAnswers = widget.timeToShowAnswer + (answers.length * 300).ms;
    _controller = AnimationController(vsync: this);

    Future.microtask(() {
      if (mounted) {
        _controller.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    pause();
    resume();
  }

  void pause() {
    onPause = true;
  }

  void resume() {
    onPause = false;
  }

  String _getRandomAnswer() {
    return answers[random.nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Animate(
      controller: _controller,
      effects: const [],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: NeonchikQuizHeader(
                        title: widget.title,
                        answers: widget.answers,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          NeonAnim1(
                            getRandomAnswer: _getRandomAnswer,
                            timeToShowAnswer: showAnswers,
                            onPressedAnswer: _onPressedAnswerSafe,
                            onPause: onPause,
                          ),
                          NeonAnim2(
                            getRandomAnswer: _getRandomAnswer,
                            timeToShowAnswer: showAnswers + 600.ms,
                            onPressedAnswer: _onPressedAnswerSafe,
                            onPause: onPause,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          NeonAnim3(
                            getRandomAnswer: _getRandomAnswer,
                            timeToShowAnswer: showAnswers + 1200.ms,
                            onPressedAnswer: _onPressedAnswerSafe,
                            onPause: onPause,
                          ),
                          NeonAnim4(
                            getRandomAnswer: _getRandomAnswer,
                            timeToShowAnswer: showAnswers + 1800.ms,
                            onPressedAnswer: _onPressedAnswerSafe,
                            onPause: onPause,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (fail)
                  const Positioned.fill(
                    child: LottieAnimation(type: LottieType.fail),
                  ),
                if (congratulation)
                  const Positioned.fill(
                    child: LottieAnimation(type: LottieType.fireworks),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _onPressedAnswerSafe(String answer) async {
    await Future.microtask(() => onPressedAnswer(answer));
  }

  Future<void> onPressedAnswer(String answer) async {
    if (onPause) return;

    pause();

    final isCorrect = await widget.onPressed.call(answer);

    if (!mounted) return;

    if (isCorrect) {
      await player.stop();
      await player.play(AssetSource('audio/win.wav'));


      if (!mounted) return;
      setState(() {
        congratulation = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.read<MonetProvider>().addMoney(50);
        Navigator.pop(context, true); // <-- Вернуть результат: ответ правильный
      }
    } else {
      await player.stop();
      await player.play(AssetSource('audio/wrong-answer.wav'));

      if (!mounted) return;
      setState(() {
        fail = true;
      });

      await Future<void>.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      setState(() {
        fail = false;
      });
      resume();

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pop(context, false); // <-- Вернуть результат: ответ неправильный
      }
    }
  }
}
