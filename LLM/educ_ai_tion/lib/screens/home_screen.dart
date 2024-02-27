// Home Screen
import 'package:educ_ai_tion/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'question_generator_screen.dart';


// Home Screen
// 
// This screen serves as the landing page of the application. 
//It provides a general overview of the app's functionality and navigational buttons to access different features, 
//such as the question generator, file upload, and settings.

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _notificationsEnabled = false; // Example setting

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher\'s Portal'),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
          color: Colors.lightBlue[100], // Changed background color to light blue
        padding: EdgeInsets.all(20.0),
          
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Included image above the buttons
            
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionGeneratorScreen()),
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
              child: Text('Generate Questions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                    onPressed: () {
                      
                    },

                            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text('Gradebook'),
            ),
            SizedBox(height: 20),
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
              child: Text('Archives'),
            ),
          ],
        ),
      ),
    );
      
    
  }
}
