import 'package:educ_ai_tion/screens/homework_screen.dart';
import 'package:educ_ai_tion/screens/homework_upload_screen.dart';
import 'package:educ_ai_tion/screens/study_activity.dart';
import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:educ_ai_tion/widgets/custom_button.dart';
import 'package:educ_ai_tion/widgets/mobile_button.dart';
import 'package:flutter/material.dart';
// Import your custom AppBar and other necessary widgets here

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

final List<Map<String, dynamic>> studentButtonData = [
  {
    'imagePath': 'assets/images/answer_key_icon.png',
    'label': 'Homework Management',
    'destination': HomeworkFileList(),
  },
  {
    'imagePath': 'assets/images/student_icon.png',
    'label': 'Study Activity',
    'destination': Activity(),
  },
  // Add more buttons as needed
];

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Student \'s Portal',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
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

  List<Widget> generateButtons(BuildContext context) {
    return studentButtonData.map((data) {
      return CustomFeatureButton(
        imagePath: data['imagePath'],
        label: data['label'],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => data['destination']),
          );
        },
      );
    }).toList();
  }

  Widget _buildTabletOrLargeScreenLayout() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: studentButtonData
                  .map((buttonData) => CustomFeatureButton(
                        imagePath: buttonData['imagePath'],
                        label: buttonData['label'],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    buttonData['destination']),
                          );
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 20), // Space between the buttons and the logo
            // Logo
            Image.asset('assets/images/logo.png',
                width: 420), // Adjust size as needed
            SizedBox(
                height:
                    60), // Space between the logo and the bottom row of buttons
            /* // Bottom row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: bottomButtonData
                  .map((buttonData) => CustomFeatureButton(
                        imagePath: buttonData['imagePath'],
                        label: buttonData['label'],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    buttonData['destination']),
                          );
                        },
                      ))
                  .toList(),
            ), */
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: SingleChildScrollView(
        // Use SingleChildScrollView to enable scrolling when needed
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/images/logo.png',
                  width: 400), // Logo at the top
            ),
            ...studentButtonData
                .map((data) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      child: MobileButton(
                        // Use your custom button widget
                        imagePath: data['imagePath'],
                        label: data['label'],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => data['destination']));
                        },
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
