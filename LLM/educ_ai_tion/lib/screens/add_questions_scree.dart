import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educ_ai_tion/models/question.dart';
import 'package:educ_ai_tion/models/difficulty_enum.dart';

class AddQuestionScreen extends StatelessWidget {
  AddQuestionScreen({super.key});
  final TextEditingController _questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Enter Question'),
              maxLines: 5, // Allow multiple lines for entering the questions
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Split the entered questions by line breaks
                List<String> questionLines =
                    _questionController.text.split('\n');

                // Save each question as a separate document in Firestore
                questionLines.forEach((questionText) {
                  // Create Question object with hardcoded values for other fields
                  Question question = Question(
                    id: '', // Firebase will generate ID
                    topic: 'Math', // Hardcoded value
                    difficulty: Difficulty.easy, // Hardcoded value
                    question: questionText
                        .trim(), // Remove leading/trailing whitespace
                    date: DateTime.now(),
                    grade: 4, // Hardcoded value
                    version: 1.0, // Hardcoded value
                    className: 'MathClass', // Hardcoded value
                  );

                  // Save question to Firestore
                  FirebaseFirestore.instance
                      .collection('questions')
                      .add(question.toMap())
                      .then((value) {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Question added successfully.'),
                    ));
                  }).catchError((error) {
                    // Show error message if there's an issue with saving the question
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to add question: $error'),
                    ));
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'User is not authenticated to save to the database'),
                  ));
                });

                // Clear text field after successful submission
                _questionController.clear();
              },
              child: Text('Save Question'),
            ),
          ],
        ),
      ),
    );
  }
}
