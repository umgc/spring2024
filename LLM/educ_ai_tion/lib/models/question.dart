// Question Model
//
// Represents the data model for a question generated by the app. It includes properties for the question text, possible answers,
//the correct answer, and any relevant metadata such as difficulty level or topic.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educ_ai_tion/utils/difficulty_enum_extension.dart';
import 'package:flutter/material.dart';
import 'difficulty_enum.dart';

class Question {
  final String id;
  final String topic;
  final Difficulty difficulty;
  final String question;
  final DateTime date;
  final int grade;
  final double version;
  final String subject;

  Question(
      {required this.id,
      required this.topic,
      required this.difficulty,
      required this.question,
      required this.date,
      required this.grade,
      required this.subject,
      required this.version});

  factory Question.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Question(
      id: snapshot.id,
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      // difficulty: DifficultyEnumExtension.difficultyToString(data['difficulty'] ?? ''),
      difficulty: (data['difficulty'] as String)
          .parseDifficulty(), // Parse the difficulty
      question: data['question'] ?? '',
      date: data['date'].toDate() ?? '',
      grade: data['grade'] ?? '',
      version: data['version'] ?? '',
    );
  }
}
