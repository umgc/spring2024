import 'package:flutter/material.dart';
import 'screens/file_upload_screen.dart';
import 'screens/question_generator_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Main Screen'),
        ),
        body: Center(
          child: Builder( // Using Builder to provide a valid context for Navigator. ensures that the context is valid when the ElevatedButton is pressed. Descendant of MaterialApp.
            builder: (BuildContext context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Welcome to ESS!'),
                  ElevatedButton(
                    onPressed: () {
                      // Using the context provided by Builder.
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FileUploadScreen()),
                      );
                    },
                    child: const Text('I want to upload a file!'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      );
                    },
                    child: const Text('Go to Settings'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionGeneratorScreen()),
                      );
                    },
                    child: const Text('Generate Questions'),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
