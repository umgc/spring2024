import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educ_ai_tion/screens/teacher_home_page.dart';
import 'package:educ_ai_tion/screens/student_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isSigningUp = false;

  Future<void> _authenticate() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      if (_isSigningUp) {
        // Check if the user exists in the 'users' collection
        bool userExists = await checkUserExists(email);

        if (!userExists) {
          // Show an error message and return if the user does not exist
          _showErrorDialog(
              'User not found. Please sign up with a valid email.');
          return;
        }
        // Proceed with user creation
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Update the 'signedIn' status to true after the first sign-up
        await updateSignedInStatus(email, true);
        print('Sign up successful!');
      } else {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        print('Sign in successful!');
      }

      // Check first login and determine user role
      determineUserRole(email).then((role) async {
        // Check first login and determine user role
        bool isTeacher = await _isTeacher(email);

        // Store the user role locally
        await storeUserRoleLocally(isTeacher ? 'teacher' : 'student');

        // Navigate to the home page upon successful authentication
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                isTeacher ? TeacherHomePage() : StudentHomePage(),
          ),
        );
      }).catchError((error) {
        print('Error determining user role: $error');
        // Handle error if role determination fails
      });
    } catch (e) {
      // Handle other authentication errors
      print('Error authenticating: $e');
      String errorMessage = 'An error occurred during authentication.';

      if (e is FirebaseAuthException) {
        // Handle specific authentication errors
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No user found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Invalid password.';
            break;
          case 'email-already-in-use':
            errorMessage = 'User already signed up. Please sign in.';
            break;
        }
      }
      // Handle the error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error Authenticating'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> checkFirstLogin(String email) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      return !snapshot.exists;
    } catch (e) {
      // Handle any errors that may occur while fetching from Firestore
      print('Error checking first login: $e');
      return false;
    }
  }

  Future<void> updateSignedInStatus(String email, bool signedIn) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .update({'signedIn': signedIn});
    } catch (e) {
      print('Error updating signedIn status: $e');
    }
  }

  Future<String> handleFirstLoginAndRole(String email) async {
    // Determine user role
    String role = await determineUserRole(email);

    // Store the user role locally
    await storeUserRoleLocally(role);

    return role;
  }

  Future<String> determineUserRole(String email) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (snapshot.exists) {
        // The user document exists, return the 'role' field
        return snapshot['role'] ?? 'student';
      } else {
        // Handle the case where the user document doesn't exist
        print('User document does not exist');
        return 'student';
      }
    } catch (e) {
      // Handle any errors that may occur while fetching from Firestore
      print('Error determining user role: $e');
      return 'student';
    }
  }

  Future<bool> _isTeacher(String email) async {
    try {
      String role = await determineUserRole(email);
      print('user role is $role');
      bool isTeacher = (role == 'teacher');
      print('is teacher? $isTeacher');
      return isTeacher;
    } catch (error) {
      print('Error determining user role: $error');
      return false;
    }
  }

  void _resetPassword() async {
    try {
      final email = _emailController.text.trim();

      if (email.isEmpty) {
        // Show a warning if the email is not provided
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Email Required'),
              content:
                  const Text('Please enter your email to reset the password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      await _auth.sendPasswordResetEmail(email: email);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content: const Text('Check your email for a password reset link.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error sending password reset email: $e');
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleSignup() {
    setState(() {
      _isSigningUp = !_isSigningUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSigningUp ? 'Sign Up' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              obscureText: !_showPassword,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _resetPassword,
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isSigningUp ? 'Sign Up' : 'Sign In'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _toggleSignup,
              child:
                  Text(_isSigningUp ? 'Switch to Login' : 'Switch to Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to store the user role locally
  Future<void> storeUserRoleLocally(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  // Function to retrieve the user role from local storage
  Future<String?> getUserRoleLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  Future<bool> checkUserExists(String email) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      return snapshot.exists;
    } catch (e) {
      // Handle any errors that may occur while fetching from Firestore
      print('Error checking user existence: $e');
      return false;
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Authenticating'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
