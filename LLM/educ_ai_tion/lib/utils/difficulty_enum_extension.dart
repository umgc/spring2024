import 'package:educ_ai_tion/models/difficulty_enum.dart';

extension DifficultyEnumExtension on String {
  Difficulty parseDifficulty() {
    switch (toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'medium':
        return Difficulty.medium;
      case 'hard':
        return Difficulty.hard;
      default:
        return Difficulty.easy;
    }
  }

  static String difficultyToString(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }
}
