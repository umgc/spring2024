import 'student.dart';

class AssignmentSubmission {
  final String assignmentId;
  final Student student;
  final List<String> answers;
  final DateTime submissionDateTime;

  AssignmentSubmission({
    required this.assignmentId,
    required this.student,
    required this.answers,
    required this.submissionDateTime,
  });
}
