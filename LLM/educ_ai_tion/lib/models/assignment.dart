// Assignment Model
//
// Represents the data model for an assignment, which is a collection of questions (question.dart) for an assignment

import 'package:flutter/material.dart';
import 'question.dart';

class Assignment {
  final String assignmentId;
  final List<Question> questions;
  final List<String> studentAnswers;
  String rubric;

  Assignment({
    required this.assignmentId,
    required this.questions,
    required this.studentAnswers,
    this.rubric = '',
  });
}
