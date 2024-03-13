import 'class_data.dart';

class GradeData {
  ClassData classObject; // the class that this grade is related to
  String assignmentName;
  double grade;

  // Constructor
  GradeData(this.classObject, this.assignmentName, this.grade);
}
