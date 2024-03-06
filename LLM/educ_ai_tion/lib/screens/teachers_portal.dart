import 'package:flutter/material.dart';
import 'question_generator_screen.dart';
import 'generated_questions_screen.dart';
import 'file_upload_screen.dart';

// Home Screen
//
// This screen serves as the landing page of the application.
//It provides a general overview of the app's functionality and navigational buttons to access different features,
//such as the question generator, file upload, and settings.

class TeachersPortal extends StatefulWidget {
  @override
  _TeachersPortalState createState() => _TeachersPortalState();
}

class _TeachersPortalState extends State<TeachersPortal> {
  bool _notificationsEnabled = false; // Example setting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher\'s Portal'),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        color: Colors.lightBlue[100], // Changed background color to light blue
        padding: const EdgeInsets.all(20.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Included image above the buttons

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionGeneratorScreen()),
                );
                // Add functionality to generate questions
                // e.g., Navigator.pushNamed(context, '/generate_questions');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Generate Questions'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Using the context provided by Builder.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FileUploadScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('I want to upload a file!'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Gradebook'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to navigate to archives
                // e.g., Navigator.pushNamed(context, '/archives');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Archives'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Added functionality for the "Generated Questions" button
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeneratedQuestionsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Generated Questions'),
            ),
          ],
        ),
      ),
    );
  }
}
