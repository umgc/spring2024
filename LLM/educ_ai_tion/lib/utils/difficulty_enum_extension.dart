import 'package:educ_ai_tion/models/difficulty_enum.dart'; 

extension DifficultyEnumExtension on String {
  Difficulty parseDifficulty() {
    switch (toLowerCase()) {
      case 'easy':
        return Difficulty.easy;
      case 'intermediate':
        return Difficulty.intermediate;
      case 'advanced':
        return Difficulty.advanced;
      default:
        return Difficulty.easy;
    }
  }

    static String difficultyToString(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.intermediate:
        return 'intermediate';
      case Difficulty.advanced:
        return 'advanced';
      
    }
  }
}
