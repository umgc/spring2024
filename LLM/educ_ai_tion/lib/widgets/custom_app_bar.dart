import 'package:educ_ai_tion/screens/file_upload_screen.dart';
import 'package:educ_ai_tion/screens/question_file_list.dart';
import 'package:educ_ai_tion/screens/question_generator_screen.dart';
import 'package:educ_ai_tion/screens/settings_screen.dart';
import 'package:educ_ai_tion/screens/teacher_home_page.dart';
import 'package:educ_ai_tion/screens/teachers_portal.dart';
import 'package:educ_ai_tion/screens/question_display_screen.dart';
import 'package:educ_ai_tion/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const CustomAppBar({
    required this.title,
    this.onMenuPressed,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  late String userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 100, 34, 153),
      title: Row(
        children: [
          const SizedBox(width: 8),
          Text(widget.title),
          const SizedBox(width: 8),
          // Image.asset(
          //   'images/logo.png',
          //   height: 20,
          // ),
          const Spacer(),
          Text(
            userName,
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 52, 43, 184),
            ),
            child: Text('Menu'),
          ),
          /* ListTile(
            title: const Text('Teacher Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TeacherHomePage()),
              );
            },
          ), 
          ListTile(
            title: const Text('Teacher Portal'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeachersPortal()),
              );
            },
          ),
          ListTile(
            title: const Text('Question Generator'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuestionGeneratorScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('I want to upload a file'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FileUploadScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Display Questions'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuestionDisplayScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Saved Questions List'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const QuestionFileList()),
              );
            },
          ),*/
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
        ],
      ),
    );
  }
}
