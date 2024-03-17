import 'dart:convert';

import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educ_ai_tion/models/question.dart';
import 'package:educ_ai_tion/models/difficulty_enum.dart';
import 'package:educ_ai_tion/data/question_data.dart';
import 'package:firebase_storage/firebase_storage.dart';

class QuestionDisplayScreen extends StatefulWidget {
  const QuestionDisplayScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionDisplayScreenState createState() => _QuestionDisplayScreenState();
}

class _QuestionDisplayScreenState extends State<QuestionDisplayScreen> {
  final QuestionData _questionData = QuestionData();
  late List<Question> _questions = [];
  int _selectedGrade = 0;
  Difficulty? _selectedDifficulty;
  List<Question> _selectedQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadAllQuestions();
  }

  Future<void> _loadAllQuestions() async {
    try {
      final List<QueryDocumentSnapshot> questionDocs =
          await _questionData.loadAllQuestions();

      setState(() {
        _questions =
            questionDocs.map((doc) => Question.fromSnapshot(doc)).toList();
        print(
            'the question size in _loadAllQuestion function is ${_questions.length}');
      });
    } catch (e) {
      print('Error loading questions: $e');
    }
  }

  List<int> _getUniqueGrades() {
    return _questions.map((question) => question.grade).toSet().toList();
  }

  List<Question> _filterQuestions() {
    return _questions.where((question) {
      final bool gradeMatch =
          _selectedGrade == 0 || question.grade == _selectedGrade;
      final bool difficultyMatch = _selectedDifficulty == null ||
          question.difficulty == _selectedDifficulty;
      return gradeMatch && difficultyMatch;
    }).toList();
  }

  void _toggleQuestionSelection(Question question) {
    setState(() {
      if (_selectedQuestions.contains(question)) {
        _selectedQuestions.remove(question);
      } else {
        _selectedQuestions.add(question);
      }
    });
  }

  void _storeSelectedQuestions(BuildContext context) async {
    try {
      // Generate the text content based on the selected questions
      String textContent = _selectedQuestions.map((question) {
        return '''
      Topic: ${question.topic}
      Question: ${question.question}
      Grade: ${question.grade}
      Difficulty: ${question.difficulty.name}
      Version: ${question.version}
      ''';
      }).join('\n\n');

      // Get the current date
      String currentDate = DateTime.now().toString();

      // Define the file name format
      String fileName =
          '${_selectedGrade}_${_selectedDifficulty?.name ?? 'All'}_$currentDate.txt';

      if (kIsWeb) {
        // For web, upload the text content directly to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref('selected_questions/$fileName');
        await storageRef.putString(textContent);
      } else {
        // For mobile, create a temporary file and upload it
        Uint8List data = utf8.encode(textContent);
        Reference storageRef =
            FirebaseStorage.instance.ref('selected_questions/$fileName');
        await storageRef.putData(data);
      }

      // Show dialog to inform the user that the file is saved
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('File Saved'),
            content: Text('File $fileName is created and saved.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      print('Selected questions stored successfully.');
    } catch (e) {
      print('Error storing selected questions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Display Questions',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 25), // Add spacing
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: DropdownButton<int>(
                  value: _selectedGrade,
                  hint: const Text('Select Grade'),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedGrade = newValue;
                      });
                    }
                  },
                  items: [0, ..._getUniqueGrades()].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value == 0 ? 'All Grades' : value.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: DropdownButton<Difficulty>(
                  value: _selectedDifficulty,
                  hint: const Text('Select Difficulty'),
                  onChanged: (Difficulty? newValue) {
                    setState(() {
                      _selectedDifficulty = newValue;
                    });
                  },
                  items: Difficulty.values.map((Difficulty value) {
                    return DropdownMenuItem<Difficulty>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Add spacing
          Expanded(
            child: SingleChildScrollView(
              child: PaginatedDataTable(
                header: const Text('Questions'),
                rowsPerPage: 5,
                columns: const [
                  DataColumn(label: Text('Select')),
                  DataColumn(label: Text('Topic')),
                  DataColumn(label: Text('Question')),
                  DataColumn(label: Text('Grade')),
                  DataColumn(label: Text('Difficulty')),
                  DataColumn(label: Text('Version')),
                ],
                source: _QuestionDataSource(
                  questions: _filterQuestions(),
                  selectedQuestions: _selectedQuestions,
                  toggleQuestionSelection: _toggleQuestionSelection,
                ),
                // Add pagination, sorting, and filtering functionality
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _selectedQuestions.isNotEmpty
                ? () => _storeSelectedQuestions(context)
                : null,
            child: const Text('Save Selected Questions'),
          ),
        ],
      ),
    );
  }
}

class _QuestionDataSource extends DataTableSource {
  final List<Question> questions;
  final List<Question> selectedQuestions;
  final Function(Question) toggleQuestionSelection;

  _QuestionDataSource({
    required this.questions,
    required this.selectedQuestions,
    required this.toggleQuestionSelection,
  });

  @override
  DataRow getRow(int index) {
    final question = questions[index];
    final isSelected = selectedQuestions.contains(question);
    return DataRow(
      selected: isSelected,
      onSelectChanged: (_) => toggleQuestionSelection(question),
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (_) => toggleQuestionSelection(question),
          ),
        ),
        DataCell(Text(question.topic)),
        DataCell(Text(question.question)),
        DataCell(Text(question.grade.toString())),
        DataCell(Text(question.difficulty.name)),
        DataCell(Text(question.version.toString())),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => questions.length;

  @override
  int get selectedRowCount => selectedQuestions.length;
}
