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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Generator'),
      ),
      body: Padding(
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
              child: const Text('Generate Questions'),
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              )
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
    );
  }
}