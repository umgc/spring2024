import 'package:flutter/material.dart';


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
  String _generatedQuestions = "";

  void _generateQuestions() async {
    // Placeholder for OpenAI API call
    // Simulate an API response
    const response = "Here will be the generated questions based on the input parameters. This is a placeholder response.";

    setState(() {
      _generatedQuestions = response;
    });
    // Future integration with OpenAI API will go here
    // You will use _controller.text as the input to the OpenAI API
  }

  void _saveResponse() {
  // Placeholder for your saving logic
  // For example, saving the _generatedQuestions to a file or cloud storage

  // Show a SnackBar upon saving
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Saved!')),
  );
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