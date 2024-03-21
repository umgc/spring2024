import 'package:educ_ai_tion/widgets/student_app_bar.dart';
import 'package:flutter/material.dart';
import 'file_upload_screen.dart';
import 'question_generator_screen.dart';
import 'grade_screen.dart';
import 'settings_screen.dart';
import 'package:flutter/material.dart';
import 'homework_screen.dart';
import 'homework_upload_screen.dart';
import 'study_activity.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(
        title: 'Student Home Page',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to ESS'),
            ElevatedButton(onPressed: ()
  { Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeworkFileList()),
              );
                print('Navigate to View Class screen');
              },
              child: const Text('Download Homework'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeworkUpload()),
              );
                print('Navigate to upload Homework');
              },
              child: const Text('Upload Homework'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Activity()),
                  );
                print('Navigate to another screen');
              },
              child: const Text('Study Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
