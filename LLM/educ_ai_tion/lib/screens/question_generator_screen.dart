import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:educ_ai_tion/models/difficulty_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/openai_services.dart';
import 'package:educ_ai_tion/models/subject_enum.dart';
import 'package:educ_ai_tion/models/question.dart';

class QuestionGeneratorScreen extends StatefulWidget {
  const QuestionGeneratorScreen({Key? key}) : super(key: key);

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
  String _numberOfQuestionsController = '1';
  final List<Subject> _subjectList = Subject.values;
  final List<int> _schoolLevels = List.generate(12, (index) => index + 1);
  final List<Difficulty> _difficultyLevels = Difficulty.values;
  final OpenAIService _openAIService = OpenAIService();
  int _numberOfQuestions = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Question Generator',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Select the number of questions and enter your question parameters:'),
            Row(
              children: [
                const Text('Number of Questions: '),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: TextEditingController(
                        text: _numberOfQuestionsController),
                    decoration: InputDecoration(
                      labelText: 'Number of Questions',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_drop_up),
                            onPressed: _incrementNumberOfQuestions,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: _decrementNumberOfQuestions,
                          ),
                        ],
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false), // Only allows integers
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only allows digits
                    onChanged: (value) {
                      _numberOfQuestionsController = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
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
            const SizedBox(height: 20),
            DropdownButtonFormField<Subject>(
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
            const SizedBox(height: 20),
            DropdownButtonFormField<Difficulty>(
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
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your question details',
                labelText: 'Question Parameters',
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
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
              child: const Text('Generate Questions'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_generatedQuestions.replaceAll('~', '')),
              ),
            ),
            if (_isLoading)
              Container(
                child: const Center(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _saveQuestionsToFirestore,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Save Response'),
            ),
            ElevatedButton(
              onPressed: _clearResponse,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: const Text('Clear Response'),
            ),
          ],
        ),
      ),
    );
  }

  void _incrementNumberOfQuestions() {
    int currentValue = int.tryParse(_numberOfQuestionsController) ?? 0;
    setState(() {
      _numberOfQuestionsController = (currentValue + 1).toString();
    });
  }

  void _decrementNumberOfQuestions() {
    int currentValue = int.tryParse(_numberOfQuestionsController) ?? 0;
    if (currentValue > 0) {
      setState(() {
        _numberOfQuestionsController = (currentValue - 1).toString();
      });
    }
  }

  void _generateQuestions() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter question parameters.')),
      );
      return;
    }

    if (_selectedSchoolLevel == null ||
        _selectedDifficultyLevel == null ||
        _selectedSubject == null ||
        _numberOfQuestions == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please select a school level, subject, difficulty, and number of questions.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final int numberOfQuestions = int.parse(_numberOfQuestionsController);

    final String prompt =
        "Create $numberOfQuestions ${_selectedSubject.toString().split('.').last} questions for a ${_selectedSchoolLevel} student at the ${_selectedDifficultyLevel.toString().split('.').last} level with these parameters: ${_controller.text}. At the end of each question, add delimiter '~'. Also create an answer key for each question and enclose within parenthesis.";

    try {
      final String response =
          await _openAIService.generateText(prompt, 'gpt-4');
      setState(() {
        _generatedQuestions = response;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to generate questions. Please try again later.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveQuestionsToFirestore() async {
    if (_generatedQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No questions to save')),
      );
      return;
    }

    try {
      final List<String> questionLines = _generatedQuestions.split('~');
      final List<String> answers =
          _extractAnswersFromPrompt(_generatedQuestions);
      final List<Future<void>> savingTasks = [];

      if (questionLines.length != answers.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Mismatch between questions and answers')),
        );
        return;
      }

      for (int i = 0; i < questionLines.length; i++) {
        final Question question = Question(
            topic: _controller.text.trim(),
            difficulty: _selectedDifficultyLevel ?? Difficulty.easy,
            question: questionLines[i].trim(),
            date: DateTime.now(),
            grade: _selectedSchoolLevel ?? 1,
            subject: _selectedSubject!,
            answer: answers[i].trim());

        final Future<void> saveTask = FirebaseFirestore.instance
            .collection('questions')
            .add(question.toMap());
        savingTasks.add(saveTask);
      }

      await Future.wait(savingTasks);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All questions added successfully.')),
      );

      setState(() {
        _generatedQuestions = "";
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save questions.')),
      );
    }
  }

  List<String> _extractAnswersFromPrompt(String prompt) {
    final RegExp regExp =
        RegExp(r'\((.*?)\)'); // Search for the text within the parenthesis
    final matches = regExp.allMatches(prompt);
    final List<String> answers = [];
    for (final match in matches) {
      final answer = match.group(1);
      if (answer != null) {
        answers.add(answer);
      }
    }
    return answers;
  }

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
}
