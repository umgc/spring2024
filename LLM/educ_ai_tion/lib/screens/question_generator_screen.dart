import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:educ_ai_tion/models/difficulty_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/openai_services.dart';
import 'package:educ_ai_tion/models/subject_enum.dart';
import 'package:educ_ai_tion/models/question.dart';

// Question Generator Screen
//
// This screen allows teachers to generate test questions using the OpenAI API.
// Users can input topics or specific questions, and the app will use the OpenAI service to generate corresponding questions and answers.
// Options for customizing the difficulty level and subject area are also provided.

/// A screen that allows users to generate questions based on input text and save them to Firestore.
class QuestionGeneratorScreen extends StatefulWidget {
  const QuestionGeneratorScreen({super.key});
  @override
  _QuestionGeneratorScreenState createState() =>
      _QuestionGeneratorScreenState();
}

class _QuestionGeneratorScreenState extends State<QuestionGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  String _generatedQuestions = "";
  int? _selectedSchoolLevel;
  Difficulty? _selectedDifficultyLevel;
  Subject? _selectedSubject;
  final List<Subject> _subjectList = Subject.values;

  // Define the grades from 1 to 12
  final List<int> _schoolLevels = List.generate(12, (index) => index + 1);
  final List<Difficulty> _difficultyLevels = Difficulty.values;

  final OpenAIService _openAIService =
      OpenAIService(); // Instantiate OpenAIService

  /// Generates questions based on the input text using the OpenAIService.
  void _generateQuestions() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter question parameters.')),
      );
      return;
    }

    if (_selectedSchoolLevel == null ||
        _selectedDifficultyLevel == null ||
        _selectedSubject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select a school level, subject, and difficulty.')),
        // Handle the case where the dropdowns are not selected
      );
      return;
    }

    final String prompt =
        "Create  $_selectedSubject questions for a $_selectedSchoolLevel student at the $_selectedDifficultyLevel level with these parameters: ${_controller.text}.";

    try {
      // Use the OpenAIService to generate questions based on the input text
      final String response = await _openAIService.generateText(prompt,
          'gpt-4'); //biggest component for integrating with openaiservice
      setState(() {
        _generatedQuestions = response;
      });
    } catch (e) {
      // todo: Handle any errors here, perhaps by showing an alert dialog or a Snackbar
      print(e); // For debugging purposes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to generate questions. Please try again later.')),
      );
    }
  }

  void _saveQuestionsToFirestore() async {
    if (_generatedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions to save')),
      );
      return;
    }

    try {
      // Split the generated questions by line breaks
      List<String> questionLines = _generatedQuestions.split('\n');

      // Save each question as a separate document in Firestore
      questionLines.forEach((questionText) {
        // Create Question object with field values
        Question question = Question(
          topic: _controller.text.trim(), // Use topic from text field
          difficulty: _selectedDifficultyLevel ??
              Difficulty.easy, // Use selected difficulty level
          question: questionText.trim(), // Remove leading/trailing whitespace
          date: DateTime.now(),
          grade: _selectedSchoolLevel ??
              1, // Use selected school level or default to 1
          subject:
              _selectedSubject!, // Use selected subject or default to empty string
        );

        // Save question to Firestore
        FirebaseFirestore.instance
            .collection('questions')
            .add(question.toMap())
            .then((value) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Question added successfully.'),
          ));
        }).catchError((error) {
          // Show error message if there's an issue with saving the question
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to add question: $error'),
          ));
        });
      });

      // Clear generated questions after successful submission
      setState(() {
        _generatedQuestions = "";
      });
    } catch (e) {
      print(e); // For debugging purposes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save questions.')),
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
      appBar: CustomAppBar(
        title: 'Question Generator',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
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
                        value: _selectedSchoolLevel?.toString(),
                        decoration: InputDecoration(
                          labelText: 'Select School Level',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _schoolLevels.map((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text('Grade $value'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedSchoolLevel = int.parse(value ?? '1');
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<Subject>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          labelText: 'Select Subject',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _subjectList.map((Subject subject) {
                          return DropdownMenuItem<Subject>(
                            value: subject,
                            child: Text(subject.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (Subject? value) {
                          setState(() {
                            _selectedSubject = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<Difficulty>(
                    value: _selectedDifficultyLevel,
                    decoration: InputDecoration(
                      labelText: 'Select Difficulty',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    items: _difficultyLevels.map((Difficulty value) {
                      return DropdownMenuItem<Difficulty>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (Difficulty? value) {
                      setState(() {
                        _selectedDifficultyLevel = value;
                      });
                    },
                  ),
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
              onPressed:
                  _saveQuestionsToFirestore, // Change 2: Updated function name to _saveQuestionsToFirestore
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
          ),
        ],
      ),
    );
  }
}




/*
  /// Saves the generated questions to Firestore.
  void _saveResponse() async {
    if (_generatedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No questions to save')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('questions').add({
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
      appBar: CustomAppBar(
        title: 'Question Generator',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
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
                        value: _selectedSchoolLevel?.toString(),
                        decoration: InputDecoration(
                          labelText: 'Select School Level',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _schoolLevels.map((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text('Grade $value'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedSchoolLevel = int.parse(value ?? '1');
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<Subject>(
                        value: _selectedSubject,
                        decoration: InputDecoration(
                          labelText: 'Select Subject',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _subjectList.map((Subject subject) {
                          return DropdownMenuItem<Subject>(
                            value: subject,
                            child: Text(subject.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (Subject? value) {
                          setState(() {
                            _selectedSubject = value;
                          });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DropdownButtonFormField<Difficulty>(
                    value: _selectedDifficultyLevel,
                    decoration: InputDecoration(
                      labelText: 'Select Difficulty',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    items: _difficultyLevels.map((Difficulty value) {
                      return DropdownMenuItem<Difficulty>(
                        value: value,
                        child: Text(value.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (Difficulty? value) {
                      setState(() {
                        _selectedDifficultyLevel = value;
                      });
                    },
                  ),
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
          ),
        ],
      ),
    );
  }
}
*/
