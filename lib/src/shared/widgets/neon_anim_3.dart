import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../quiz/decoration/decorations.dart';
import 'lottie_animation.dart';
import 'neonchik_answer.dart';

class NeonAnim3 extends StatefulWidget {
  const NeonAnim3({
    required this.getRandomAnswer,
    required this.onPressedAnswer,
    super.key,
    this.onPause = false,
    this.timeToShowAnswer = const Duration(seconds: 3),
  });

  final Future<void> Function(String answer) onPressedAnswer;

  final Duration timeToShowAnswer;

  final String Function() getRandomAnswer;

  final bool onPause;

  @override
  State<NeonAnim3> createState() => _NeonAnim3State();
}

class _NeonAnim3State extends State<NeonAnim3> with TickerProviderStateMixin {
  late String answer;

  late final AnimationController _controller;

  late bool onPause;

  @override
  void didUpdateWidget(covariant NeonAnim3 oldWidget) {
    onPause = widget.onPause;

    if (onPause) {
      _controller.stop(canceled: false);
    } else {
      _controller.status.isForwardOrCompleted
          ? _controller.reverse()
          : _controller.forward();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    onPause = widget.onPause;

    answer = widget.getRandomAnswer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() async {
        if (!_controller.isAnimating &&
            _controller.value == _controller.upperBound) {
          await Future<void>.delayed(Durations.long4);

          answer = widget.getRandomAnswer();

          if (!onPause) unawaited(_controller.reverse());
        }

        if (!_controller.isAnimating &&
            _controller.value == _controller.lowerBound) {
          await Future<void>.delayed(Durations.long4);

          if (!onPause) unawaited(_controller.forward());
        }
      });

    Future<void>.delayed(
      widget.timeToShowAnswer,
      () => _controller.reverse(from: 1),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Positioned.fill(
              //   child: Container(
              //     decoration: bgDecoration,
              //   ),
              // ),
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return Align(
                    alignment: Alignment.center.add(
                      Alignment(
                        0,
                        Curves.easeIn.transform(
                              _controller.value,
                            ) -
                            0.1 * 5,
                      ),
                    ),
                    child: Transform.scale(
                      scale: 1 - _controller.value,
                      child: NeonchikAnswer(
                        answer: answer,
                        onPressed: () {
                          widget.onPressedAnswer(answer);
                        },
                        width: constraints.maxWidth * 0.5,
                      ),
                    ),
                  );
                },
              ),
              IgnorePointer(
                child: Align(
                  alignment:
                      Alignment.bottomCenter.add(const Alignment(0, -0.8)),
                  child: const LottieAnimation(),
                ),
              ),
            ],
          ).animate().fadeIn(
                duration: 600.ms,
                delay: widget.timeToShowAnswer + 600.ms,
              );
        },
      ),
    );
  }
}
