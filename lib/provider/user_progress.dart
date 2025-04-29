class UserProgress {
  int currentLevel = 1;
  final int totalLevels;

  UserProgress({this.totalLevels = 10});

  void levelCompleted() {
    if (currentLevel < totalLevels) {
      currentLevel++;
    }
  }

  bool hasCompletedAllLevels() {
    return currentLevel == totalLevels;
  }
}