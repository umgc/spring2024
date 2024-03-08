import 'package:flutter/material.dart';
import '../services/openai_services.dart'; // Ensure this import matches the location of your OpenAIService class
import 'package:cloud_firestore/cloud_firestore.dart';




// Question Generator Screen
// 
// This screen allows teachers to generate test questions using the OpenAI API. 
// Users can input topics or specific questions, and the app will use the OpenAI service to generate corresponding questions and answers. 
// Options for customizing the difficulty level and subject area are also provided.

class QuestionGeneratorScreen extends StatefulWidget {
  @override
  _QuestionGeneratorScreenState createState() => _QuestionGeneratorScreenState();
}

class _QuestionGeneratorScreenState extends State<QuestionGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  final OpenAIService _openAIService = OpenAIService();
  String _generatedQuestions = "";
  
  String? _selectedSchoolLevel;
  String? _selectedDifficulty;

  final List<String> _schoolLevels = ['High-School', 'Middle School', 'Elementary School'];
  final List<String> _difficultyLevels = ['Hard', 'Medium', 'Easy'];

  void _generateQuestions() async {
     if (_controller.text.isEmpty) {
      // Optionally handle the case where the text field is empty
      return;
    }
    try {
      // Use the OpenAIService to generate questions based on the input text
      final String response = await _openAIService.generateText(
          _controller.text,
          'gpt-3.5-turbo'); //biggest component for integrating with openaiservice
      setState(() {
        _generatedQuestions = response;
      });
    } catch (e) {
      // Handle any errors here, perhaps by showing an alert dialog or a Snackbar
      print(e); // For debugging purposes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to generate questions. Please try again later.')),
      );
    }
  }

  void _saveResponse() async {
  if (_generatedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions to save')),
      );
      return;
    }

    try {
      // Assuming you have a Firestore collection named 'generated_questions'
      await FirebaseFirestore.instance.collection('generated_questions').add({
        'questions': _generatedQuestions,
        'created_at':
            FieldValue.serverTimestamp(), // Automatically set the timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Questions saved successfully!')),
      );
    } catch (e) {
      print(e); // For debugging purposes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save questions.')),
      );
    }
}

  void _clearResponse() async {
    final bool confirmClear = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to clear the generated questions?'),
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
    ) ?? false; 
    if (confirmClear){
      setState(() {
        _generatedQuestions = "";
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Generator'),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enter your question parameters:'),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'e.g., "Create three high-school level problems..."',
              ),
              maxLines: 5,
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
              child: const Text('Generate Questions')
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_generatedQuestions),
                  ),
                ),
              ],
            ),
          ),
           Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _saveResponse,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
              ),
              child: const Text('Save Response'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _clearResponse,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red, // Text color
              ),
              child: const Text('Clear Response'),
            ),
          )
        ],
      ),
    );
  }
}