// Question Model
//
// Represents the data model for a question generated by the app. It includes properties for the question text, possible answers,
//the correct answer, and any relevant metadata such as difficulty level or topic.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'difficulty_enum.dart';
import 'subject_enum.dart';

class Question {
  final String topic;
  final Difficulty difficulty;
  final String question;
  final DateTime date;
  final int grade;
  final Subject subject;

  Question(
      {required this.topic,
      required this.difficulty,
      required this.question,
      required this.date,
      required this.grade,
      required this.subject});

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'difficulty': difficulty.toString().split('.').last.toLowerCase(),
      'question': question,
      'date': date,
      'grade': grade,
      'subject': subject.toString().split('.').last.toLowerCase(),
    };
  }

  factory Question.fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Question(
      subject: data['subject'] ?? '',
      topic: data['topic'] ?? '',
      difficulty: Difficulty.values.firstWhere(
        (e) => e.toString().split('.').last == data['difficulty'],
        orElse: () => Difficulty.easy,
      ),
      question: data['question'] ?? '',
      date: data['date'].toDate() ?? '',
      grade: data['grade'] ?? '',
    );
  }
}
