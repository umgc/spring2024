import 'package:educ_ai_tion/screens/student_home_page.dart';
import 'package:educ_ai_tion/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const StudentAppBar({
    required this.title,
    this.onMenuPressed,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _StudentAppBarState createState() => _StudentAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StudentAppBarState extends State<StudentAppBar> {
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
      backgroundColor: Colors.blueAccent,
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
              color: Colors.cyanAccent,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Student Homepage'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentHomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('View a Class'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentHomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('View Grades'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentHomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Another option'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StudentHomePage()),
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
