import 'package:educ_ai_tion/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educ_ai_tion/services/question_data.dart';
import 'package:educ_ai_tion/services/question_data.dart';

class GeneratedQuestionsScreen extends StatelessWidget {
  final QuestionData questionData = QuestionData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Generated Questions',
        onMenuPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      drawer: const DrawerMenu(),
      body: FutureBuilder(
        future: loadQuestions(),
        builder:
            (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('No data available');
          } else {
            List<QueryDocumentSnapshot> questions = snapshot.data!;
            return PageView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var questionData =
                    questions[index].data() as Map<String, dynamic>;
                return Card(
                  elevation: 5.0,
                  margin: EdgeInsets.all(10.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Question ${index + 1}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text('Text: ${questionData['question']}'),
                        Text('Difficulty: ${questionData['difficulty']}'),
                        Text('Class Name: ${questionData['className']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> loadQuestions() async {
    return questionData.loadQuestions();
  }
}
