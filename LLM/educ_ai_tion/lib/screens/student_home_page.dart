import 'package:flutter/material.dart';
import 'file_upload_screen.dart';
import 'question_generator_screen.dart';
import 'grade_screen.dart';
import 'settings_screen.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to ESS'),
            ElevatedButton(
              onPressed: () {
                // You can implement the logic to navigate to the "View Class" screen
                // when this button is pressed
                print('Navigate to View Class screen');
              },
              child: const Text('View a Class'),
            ),
            ElevatedButton(
              onPressed: () {
                // You can implement the logic to navigate to the "View Grades" screen
                // when this button is pressed
                print('Navigate to View Grades screen');
              },
              child: const Text('View Grades'),
            ),
            ElevatedButton(
              onPressed: () {
                // You can implement the logic to navigate to other screens
                // when this button is pressed
                print('Navigate to another screen');
              },
              child: const Text('Another Option'),
            ),
          ],
        ),
      ),
    );
  }
}
