import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../services/openai_services.dart'; // Ensure this import matches the location of your OpenAIService class
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


// Grading Screen
//
// This screen allows teachers to grade assignments using the OpenAI API.
// Users can copy questions, a rubric and students completed assingments

/// A screen that allows users to grade questions based on input text.
class GradingScreen extends StatefulWidget {
  const GradingScreen({super.key});
  @override
  _GradingScreenState createState() => _GradingScreenState();
}

class _GradingScreenState extends State<GradingScreen> {
  final TextEditingController _controllerOne = TextEditingController();
  final TextEditingController _controllerTwo = TextEditingController();
  final TextEditingController _controllerThree = TextEditingController();

  bool _isLoading = false;
  String _grade = "";

  final OpenAIService _openAIService =
      OpenAIService(); // Instantiate your OpenAIService

  final Reference storageRef =
      FirebaseStorage.instance.ref().child('selected_questions');
  List<String> fileNames = [];
  String? selectedFile;

  @override
  void initState() {
    super.initState();
    _fetchFileNames();
  }

  Future<void> _fetchFileNames() async {
    try{
      final result = await storageRef.listAll();
      final names = result.items.map((item) => item.name).where((name) => name.endsWith('.txt')).toList();
      setState((){
        fileNames = names;
      });
      } catch (e) {
        print('Error fetching file names: $e');
      }
    }

 Future<void> _fetchFileContent(String fileName) async {
  try {
    final downloadUrl = await storageRef.child(fileName).getDownloadURL();
    final response = await http.get(Uri.parse(downloadUrl));

    if (response.statusCode == 200) {
      // If the server returns an OK response, update the text controller
      setState(() {
        _controllerOne.text = response.body;
      });
    } else {
      // If the server did not return an OK response, throw an error
      print('Failed to load file content');
    }
  } catch (e) {
    print('Error fetching file content: $e');
  }
}
  

  /// Generates questions based on the input text using the OpenAIService.
  void _generateQuestions() async {
    if (_controllerOne.text.isEmpty) {
      // Optionally handle the case where the text field is empty
      return;
    }
    if (_controllerTwo.text.isEmpty || _controllerThree.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Please enter the assignment, rubric, and students answers.')),
        // Optionally handle the case where the dropdowns are not selected
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String prompt =
        "For the questions ${_controllerOne.text} grade the following answers ${_controllerTwo.text} based on the following answers: ${_controllerThree.text}.";

    try {
      // Use the OpenAIService to grade questions based on the input text
      final String response = await _openAIService.generateText(prompt,
          'gpt-4'); //biggest component for integrating with openaiservice
      setState(() {
        _grade = response;
      });
    } catch (e) {
      // Handle any errors here, perhaps by showing an alert dialog or a Snackbar
      print(e); // For debugging purposes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to generate grades. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Clears the generated grade.
  void _clearResponse() async {
    final bool confirmClear = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Are you sure you want to clear the grade?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (confirmClear) {
      setState(() {
        _grade = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Assignment Grading',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      //drawer: const DrawerMenu(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ if (fileNames.isNotEmpty) ...[
                Text("Select Assignment Questions:"),
                DropdownButton<String>(
                  value: selectedFile,
                  hint: Text('Select a file'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFile = newValue;
                      _fetchFileContent(newValue!); // This function needs to be defined to fetch the content
                    });
                  },
                  items: fileNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 20),
                const Text('Copy the assignment questions here:'),
                TextField(
                  controller: _controllerOne,
                  decoration: const InputDecoration(
                    hintText: 'e.g., "Question 1. .."',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter your rubric for grading:'),
                    TextField(
                      controller: _controllerTwo,
                      decoration: const InputDecoration(
                        hintText:
                            'e.g., "1 point each question for correct grammer, 2 points each question for correct content. . ."',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Copy the students answers:'),
                    TextField(
                      controller: _controllerThree,
                      decoration: const InputDecoration(
                        hintText: 'e.g., "1. the first president was ..."',
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: _generateQuestions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Grade Questions')),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(_grade),
                  ),
                ),
                if (_isLoading) // Check if the app is currently loading
          Center(
            child: CircularProgressIndicator(), // Show loading indicator
          ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _clearResponse,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              child: const Text('Clear Response'),
            ),
          )
        ],
      ),
    );
  }
}
