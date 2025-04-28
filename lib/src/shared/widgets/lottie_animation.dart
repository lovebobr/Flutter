import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

enum LottieType { fail, fireworks, portal }

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({super.key, this.type = LottieType.portal, this.width});

  final LottieType type;

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/animations/${type.name}.json', width: width);
  }
}
