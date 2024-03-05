// Home Screen
import 'package:educ_ai_tion/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'question_generator_screen.dart';
import 'generated_questions_screen.dart';
import 'file_upload_screen.dart';


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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // For tablets or larger screens
            return _buildTabletOrLargeScreenLayout();
          } else {
            // For smaller screens
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildTabletOrLargeScreenLayout() {
    return Container(
      color: Colors.lightBlue[100],
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
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
                  minimumSize: Size(200, 50),
                ),
                child: Text('Upload File'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(200, 50),
                ),
                child: Text('Gradebook'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(200, 50),
                ),
                child: Text('Archives'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GeneratedQuestionsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(200, 50),
                ),
                child: Text('Generated Questions'),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionGeneratorScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(300, 100),
                    ),
                    child: Text(
                      'Generate Questions',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      color: Colors.lightBlue[100],
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuestionGeneratorScreen()),
              );
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
          ElevatedButton(
            onPressed: () {
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
            child: Text('Upload File'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Gradebook'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
                        child: Text('Gradebook'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Archives'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeneratedQuestionsScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Generated Questions'),
          ),
        ],
      ),
    );
  }
}
