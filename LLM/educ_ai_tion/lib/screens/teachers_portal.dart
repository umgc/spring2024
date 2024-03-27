import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:educ_ai_tion/widgets/custom_button.dart';
import 'package:educ_ai_tion/widgets/mobile_button.dart';
import 'package:flutter/material.dart';
import 'question_generator_screen.dart';
import 'generated_questions_screen.dart';
import 'file_upload_screen.dart';
import 'grade_screen.dart';
import 'question_file_list.dart';
import 'question_display_screen.dart';
import 'suggest_activity.dart';

// Teacher's Portal

class TeachersPortal extends StatefulWidget {
  const TeachersPortal({super.key});
  @override
  _TeachersPortalState createState() => _TeachersPortalState();
}

final List<Map<String, dynamic>> topButtonData = [
  {
    'imagePath': 'assets/images/assignment_icon.png',
    'label': 'Generate Questions',
    'destination': QuestionGeneratorScreen(),
  },
  {
    'imagePath': 'assets/images/answer_key_icon.png',
    'label': 'Upload File',
    'destination': FileUploadScreen(),
  },
  {
    'type': 'button',
    'imagePath': 'assets/images/suggest_activity_icon.png',
    'label': 'Activity Suggestions',
    'destination': SuggestScreen(),
  },
];

final List<Map<String, dynamic>> bottomButtonData = [
  {
    'imagePath': 'assets/images/grade_icon.png',
    'label': 'Grade',
    'destination': GradingScreen(),
  },
  {
    'imagePath': 'assets/images/resources_icon.png',
    'label': 'Archives',
    'destination': QuestionFileList(),
  },
  {
    'imagePath': 'assets/images/activity_icon.png',
    'label': 'Display Screen',
    'destination': QuestionDisplayScreen(),
  },
];

final List<Map<String, dynamic>> buttonData = new List.from(topButtonData)
  ..addAll(bottomButtonData);

class _TeachersPortalState extends State<TeachersPortal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Teacher \'s Portal',
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
    return buttonData.map((data) {
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
            // Top row of buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: topButtonData
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
            // Bottom row of buttons
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
            ),
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
            ...buttonData
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
