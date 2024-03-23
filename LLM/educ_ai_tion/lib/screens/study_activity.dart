import 'package:flutter/material.dart';
import 'question_generator_screen.dart';
import 'generated_questions_screen.dart';
import 'file_upload_screen.dart';
import '../services/openai_services.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  String _generatedQuestions = "";
  bool _isLoading = false;

  String? _selectedSchoolLevel;
  String? _selectedDifficultyLevel;

  final List<String> _schoolLevels = ['High-School', 'Middle School', 'Elementary School', 'University'];
  final List<String> _difficultyLevels = ['Hard', 'Medium', 'Easy'];

  final OpenAIService _openAIService =
      OpenAIService(); // Instantiate your OpenAIService

  /// Generates questions based on the input text using the OpenAIService.
  void _generateQuestions() async {
    if (_controller1.text.isEmpty) {
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
    setState(() {
      _isLoading = true;
    });

    final String prompt =
        "Create questions for a $_selectedSchoolLevel student at the $_selectedDifficultyLevel level with these parameters: ${_controller1.text}.";

    try {
      // Use the OpenAIService to generate questions based on the input text
      final String response = await _openAIService.generateText(prompt,
          'gpt-4-turbo-preview'); //biggest component for integrating with openaiservice
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Saves the generated questions to Firestore.
  void _saveResponse() async {
    if (_generatedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No suggestions')),
      );
      return;
    }
final String prompt2 =
        "Are the following answers correct?  If not, give me a hint but don't tell me the answers: ${_controller2.text}.";

    try {
      // Use the OpenAIService to generate questions based on the input text
      final String response = await _openAIService.generateText(prompt2,
          'gpt-4-turbo-preview'); //biggest component for integrating with openaiservice
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
        title: Text('Study Activity Generator'),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Enter information about the topic you would like to study:'),
                TextField(
                  controller: _controller1,
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
                        onChanged: (value) {
                          setState(() {
                            _selectedSchoolLevel = value;
                          });
                        },
                        items: _schoolLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select School Level',
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDifficultyLevel,
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficultyLevel = value;
                          });
                        },
                        items: _difficultyLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Select Difficulty',
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller2,
                  decoration: const InputDecoration(
                    labelText: 'Answers',
                    border: OutlineInputBorder(),
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
                  child: const Text('Generate Questions'),
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
           if (_isLoading) // Check if the app is currently loading
          Center(
            child: CircularProgressIndicator(), // Show loading indicator
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _saveResponse,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Check Answers'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: _clearResponse,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Clear Response'),
            ),
          ),
        ],
      ),
    );
  }
}   