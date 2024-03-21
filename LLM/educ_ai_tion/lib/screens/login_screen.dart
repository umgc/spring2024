import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:educ_ai_tion/screens/teacher_home_page.dart';
import 'package:educ_ai_tion/screens/student_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  bool _isPasswordValid = false;

  Future<void> _authenticate() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      if (_isSigningUp) {
        // Check if the user exists in the 'users' collection
        bool userExists = await checkUserExists(email);
        // Validate password length
        if (password.length < 6) {
          _showErrorDialog('Password must be at least 6 characters long.');
          return;
        }
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
        // Update the 'signedUp' status to true after the first sign-up
        await updateSignedUpStatus(email, true);
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

  Future<void> updateSignedUpStatus(String email, bool signedUp) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .update({'signedUp': signedUp});
    } catch (e) {
      print('Error updating signedUp status: $e');
    }
  }

  Future<String> handleFirstLoginAndRole(String email) async {
    // Determine user role
    String role = await determineUserRole(email);

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
      bool isTeacher = (role == 'teacher');
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
    print("Building LoginScreen");
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
              onChanged: (value) {
                // Triggered every time the password field changes
                setState(() {
                  // Check if the password is at least 6 characters long
                  _isPasswordValid = value.length >= 6;
                });
              },
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
            if (_isSigningUp && _passwordController.text.length < 6)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Password must be at least 6 characters long.',
                    style: TextStyle(color: Color.fromARGB(255, 63, 16, 151)),
                  ),
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

  Future<bool> checkUserExists(String email) async {
    try {
      print("the email is '$email'");
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
