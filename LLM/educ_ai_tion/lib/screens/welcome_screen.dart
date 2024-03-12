import 'package:educ_ai_tion/screens/login_screen.dart';
import 'package:flutter/material.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Educ_ai_tion'),
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView for vertical scrolling
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // First Row
            SizedBox(
              width: screenWidth * 0.9, // 90% of screen width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // First Column
                  SizedBox(
                    width: screenWidth * 0.4, // 40% of screen width
                    child: Column(
                      children: <Widget>[
                        Image.asset('images/home_image_top.png'), 
                        
                      ],
                    ),
                  ),
                
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacer between rows
            // Second Row
            
            
            SizedBox(
              width: screenWidth * 0.9, // 90% of screen width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // First Column
                  SizedBox(
                    width: screenWidth * 0.4, // 40% of screen width
                    child: Column(
                      children: <Widget>[
                        Image.asset('images/home_image_empTeacher.PNG'), 
                        
                      ],
                    ),
                  ),
                  // Second Column
                  SizedBox(
                    width: screenWidth * 0.4, // 40% of screen width
                    child: const Column(
                      children: <Widget>[
                        Text('Empowering Teachers'),
                        Text('Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacer between rows
            // third Row
            
            SizedBox(
              width: screenWidth * 0.9, // 90% of screen width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // First Column
                  SizedBox(
                    width: screenWidth * 0.4, // 40% of screen width
                    child: const Column(
                      children: <Widget>[
                        
                        Text('Create Interactive Quizzes and Tests'),
                        Text('Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..Efficient course planning tools to save time for teachers..'),
                      ],
                    ),
                  ),
                  // Second Column
                  SizedBox(
                    width: screenWidth * 0.4, // 40% of screen width
                    child: Column(
                      children: <Widget>[
                        Image.asset('images/home_image_createInteractive.PNG'), 
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Spacer between rows
            // fourth Row
            SizedBox(
              width: screenWidth * 0.9, // 90% of screen width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push( // Navigate to student login page
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                    },
                    child: const Text('login to ESS'),
                  ),
                 
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
