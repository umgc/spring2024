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

  Future<List<QueryDocumentSnapshot>> loadQuestions({
    String? topic,
    Difficulty? difficulty,
  }) async {
    try {
      Query query = FirebaseFirestore.instance.collection('questions');
      if (topic != null) {
        query = query.where('topic', isEqualTo: topic);
      }

      if (difficulty != null) {
        query = query.where('difficulty', isEqualTo: difficulty.name);
      }

      QuerySnapshot querySnapshot = await query.get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error loading questions: $e');
      throw e;
    }
  }

  
  Future<List<QueryDocumentSnapshot>> loadAllQuestions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('questions').orderBy('topic').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error loading questions: $e');
      throw e;
    }
  }
}
