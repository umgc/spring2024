import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class HomeworkFileList extends StatefulWidget {
  const HomeworkFileList({Key? key});

  @override
  _HomeworkFileState createState() => _HomeworkFileState();
}

class _HomeworkFileState extends State<HomeworkFileList> {
  final TextEditingController _controllerOne = TextEditingController();
  final TextEditingController _controllerTwo = TextEditingController();
  final TextEditingController _controllerThree = TextEditingController();
  final TextEditingController _controllerFour = TextEditingController();
  final TextEditingController _controllerFive = TextEditingController();

 final Reference storageRef =
      FirebaseStorage.instance.ref().child('selected_questions');
  List<String> fileNames = [];
  String? selectedFile;


  final AssignmentData _assignmentData =
      AssignmentData(); // Instance of AssignmentData

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

  Future<void> _saveSubmission() async {
    try {
      // Create a new AssignmentSubmission object with data from text fields
      AssignmentSubmission submission = AssignmentSubmission(
        assignmentId:
            selectedFile ?? '', // Assuming selectedFile contains assignment ID
        student: Student(
          firstName: _controllerTwo.text.trim(),
          lastName: _controllerThree.text.trim(),
          email: _controllerFour.text
              .trim(), // Assuming _controllerFour for email field
        ),
        answers: _controllerFive.text.trim(),
        submissionDateTime: DateTime.now(),
      );

      // Call the addAssignmentSubmission method from AssignmentData to save the submission
      await _assignmentData.addAssignmentSubmission(submission);

      Fluttertoast.showToast(msg: 'Submission saved to Firebase');
      _clearFields(); // Clear text fields after successful submission
    } catch (e) {
      print('Error saving submission: $e');
      Fluttertoast.showToast(msg: 'Error saving submission');
    }
  }

  void _clearFields() {
    _controllerOne.clear();
    _controllerTwo.clear();
    _controllerThree.clear();
    _controllerFour.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grading Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Assignment Questions:"),
            DropdownButton<String>(
              value: selectedFile,
              hint: Text('Select a file'),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFile = newValue;
                  _fetchFileContent(newValue!);
                });
              },
              items: fileNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text('File Content:'),
            TextField(
              controller: _controllerOne,
              decoration: InputDecoration(
                hintText: 'File content will be displayed here',
              ),
              maxLines: 10,
              readOnly: true,
            ),
            SizedBox(height: 10),
            Text('Student First Name:'),
            TextField(
              controller: _controllerTwo,
              decoration: InputDecoration(
                hintText: 'Enter student first name',
              ),
            ),
            SizedBox(height: 10),
            Text('Student Last Name:'),
            TextField(
              controller: _controllerThree,
              decoration: InputDecoration(
                hintText: 'Enter student last name',
              ),
            ),
            SizedBox(height: 10),
            Text('Student Email:'),
            TextField(
              controller: _controllerFour,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
             SizedBox(height: 10),
            Text('Enter Answers:'),
            TextField(
              controller: _controllerFive,
              decoration: InputDecoration(
                hintText: 'Enter your answers',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveSubmission,
              child: Text('Save Submission'),
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentSubmission {
  final String assignmentId;
  final Student student;
  final String answers;
  final DateTime submissionDateTime;

  AssignmentSubmission({
    required this.assignmentId,
    required this.student,
    required this.answers,
    required this.submissionDateTime,
  });
}

class Student {
  final String firstName;
  final String lastName;
  final String email;

  Student({
    required this.firstName,
    required this.lastName,
    required this.email,
  });
}

class AssignmentData {
  Future<void> addAssignmentSubmission(AssignmentSubmission submission) async {
    try {
      await FirebaseFirestore.instance
          .collection('assignment_submissions')
          .doc(submission.assignmentId)
          .set({
        'studentFirstName': submission.student.firstName,
        'studentLastName': submission.student.lastName,
        'studentEmail': submission.student.email,
        'answers': submission.answers,
        'submissionDateTime': submission.submissionDateTime,
      });
    } catch (e) {
      print('Error adding assignment submission: $e');
      throw e;
    }
  }
}