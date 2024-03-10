import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/openai_services.dart'; // Ensure this import matches the location of your OpenAIService class

// Question Generator Screen
//
// This screen allows teachers to generate test questions using the OpenAI API.
// Users can input topics or specific questions, and the app will use the OpenAI service to generate corresponding questions and answers.
// Options for customizing the difficulty level and subject area are also provided.

/// A screen that allows users to generate questions based on input text and save them to Firestore.
class QuestionGeneratorScreen extends StatefulWidget {
  @override
  _QuestionGeneratorScreenState createState() =>
      _QuestionGeneratorScreenState();
}

class _QuestionGeneratorScreenState extends State<QuestionGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  String _generatedQuestions = "";

  String? _selectedSchoolLevel;
  String? _selectedDifficultyLevel;

  final List<String> _schoolLevels = [
    'High-School',
    'Middle School',
    'Elementary School'
  ];
  final List<String> _difficultyLevels = ['Hard', 'Medium', 'Easy'];

  final OpenAIService _openAIService =
      OpenAIService(); // Instantiate your OpenAIService

  /// Generates questions based on the input text using the OpenAIService.
  void _generateQuestions() async {
    if (_controller.text.isEmpty) {
      // Optionally handle the case where the text field is empty
      return;
    }
    if (_selectedSchoolLevel == null || _selectedDifficultyLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a school level and difficulty.')),
        // Optionally handle the case where the dropdowns are not selected
      );
      return;
    }
    final String prompt =
        "Create questions for a $_selectedSchoolLevel student at the $_selectedDifficultyLevel level with these parameters: ${_controller.text}.";

    try {
      // Use the OpenAIService to generate questions based on the input text
      final String response = await _openAIService.generateText(prompt,
          'gpt-3.5-turbo'); //biggest component for integrating with openaiservice
      setState(() {
        _generatedQuestions = response;
      });
    } catch (e) {
      // Handle any errors here, perhaps by showing an alert dialog or a Snackbar
      print(e); // For debugging purposes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to generate questions. Please try again later.')),
      );
    }
  }

  /// Saves the generated questions to Firestore.
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

  /// Clears the generated questions.
  void _clearResponse() async {
    final bool confirmClear = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text(
                  'Are you sure you want to clear the generated questions?'),
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
                const Text(
                    'Enter your question parameters, such as number of questions and topic:'),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'e.g., "Create three problems..."',
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSchoolLevel,
                        decoration: InputDecoration(
                          labelText: 'Select School Level',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _schoolLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSchoolLevel = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20), // Add spacing between dropdowns
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDifficultyLevel,
                        decoration: InputDecoration(
                          labelText: 'Select Difficulty',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _difficultyLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficultyLevel = value;
                          });
                        },
                      ),
                    ),
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
                    child: const Text('Generate Questions')),
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
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
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
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Text color
              ),
              child: const Text('Clear Response'),
            ),
          )
        ],
      ),
    );
  }
}
