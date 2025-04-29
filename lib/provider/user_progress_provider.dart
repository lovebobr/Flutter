import 'package:flutter/material.dart';
import 'user_progress.dart';

class UserProgressProvider with ChangeNotifier {
  UserProgress _userProgress = UserProgress(totalLevels: 10);

  UserProgress get progress => _userProgress;

  void levelCompleted() {
    _userProgress.levelCompleted();
    notifyListeners();
  }

  bool hasCompletedAllLevels() {
    return _userProgress.hasCompletedAllLevels();
  }
}