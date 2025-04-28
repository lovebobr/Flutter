import 'package:flutter/material.dart';

class NeonchikQuizBlock extends StatelessWidget {
  const NeonchikQuizBlock({
    required this.animation,
    required this.answer,
    required this.onPressedAnswer,
    required this.alignment,
    this.children = const [],
    super.key,
  });

  final AnimationController animation;

  final AlignmentGeometry alignment;

  final String answer;

  final void Function(String answer) onPressedAnswer;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/bg.png'),
                  ),
                ),
              ),
            ),
            ...children,
          ],
        );
      },
    );
  }
}
