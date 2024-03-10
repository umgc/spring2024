import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educ_ai_tion/models/assignment_submission.dart';

class AssignmentData {
  Future<void> addAssignmentSubmission(AssignmentSubmission submission) async {
    try {
      await FirebaseFirestore.instance
          .collection('assignment_submissions')
          .doc(submission.assignmentId)
          .set({
        'student': submission.student,
        'answers': submission.answers,
        'submissionDateTime': submission.submissionDateTime,
      });
    } catch (e) {
      print('Error adding assignment submission: $e');
      throw e;
    }
  }
}
