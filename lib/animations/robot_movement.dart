import 'dart:ui';
import 'package:flutter/animation.dart';

class RobotMovementController {
  RobotMovementController({
    required this.points,
    required TickerProvider vsync,
    required this.onUpdate,
  }) {
    _controller = AnimationController(vsync: vsync)
      ..addListener(_handleTick)
      ..addStatusListener(_handleStatus);
  }

  final List<Offset> points;
  final VoidCallback onUpdate;

  late AnimationController _controller;
  Animation<Offset>? _animation;
  VoidCallback? _onComplete;

  Offset currentRobotPosition = Offset.zero;
  int _currentIndex = 0;

  void moveTo(int index, int durationMs) {
    if (index < 0 || index >= points.length  || index == _currentIndex) return;

    final start = points[_currentIndex];
    final end = points[index];

    _animation = Tween<Offset>(begin: start, end: end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.duration = Duration(milliseconds: durationMs);
    _controller.forward(from: 0.0);

    _currentIndex = index;
  }

  void _handleTick() {
    if (_animation != null) {
      currentRobotPosition = _animation!.value;
      onUpdate();
    }
  }

  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (_onComplete != null) {
        _onComplete!();
        _onComplete = null;
      }
    }
  }

  void addOnCompleteListener(VoidCallback callback) {
    _onComplete = callback;
  }
  void dispose() {
    _controller.dispose();
  }
}