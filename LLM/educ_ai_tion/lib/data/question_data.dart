import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:educ_ai_tion/models/difficulty_enum.dart';
import 'package:educ_ai_tion/models/question.dart';

class QuestionData {
  Future<void> addQuestion(Question question) async {
    try {
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(question.id)
          .set({
        'className': question.className,
        'topic': question.topic,
        'difficulty': question.difficulty.name,
        'id': question.id,
        'question': question.question,
        'date': question.date,
        'grade': question.grade,
        'version': question.version,
      });
    } catch (e) {
      print('Error adding question: $e');
    }
  }
}
