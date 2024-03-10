import 'class_data.dart';
import 'grade_data.dart';

// Student Class
class Student {
  // Attributes
  String firstName;
  String lastName;
  String email; //primary key
  List<GradeData> gradeList;
  List<ClassData> classList;

  Student(this.firstName, this.lastName, this.email)
      : classList = [],
        gradeList = [];

  void enroll(String className) {
    // todo: write implementation
  }

  void dropClass(String className) {
    // todo: write implementation
  }

  double getOverallGrade() {
    // Average the grades in gradeList
    if (gradeList.isEmpty) return 0.0;
    return gradeList.map((grade) => grade.grade).reduce((a, b) => a + b) /
        gradeList.length;
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getEmail() {
    return email;
  }

  List<ClassData> getClassList() {
    return classList;
  }

  List<GradeData> getGradeList() {
    return gradeList;
  }

  //GradeData getGradeByClass(String className) {
  // todo: write implementation

  //}

  void submitTest(String testID, String submissionContent) {
    // todo: write implementation
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  void setEmail(String email) {
    this.email = email;
  }
}
