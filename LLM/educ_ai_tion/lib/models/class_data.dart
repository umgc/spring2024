// ClassData Class
import 'teacher.dart';
import 'student.dart';
import 'grade_data.dart';
import 'subject_enum.dart';

class ClassData {
  String className; //primary key
  Teacher teacher;
  Subject subject;
  List<Student> studentList;

  ClassData(this.className, this.teacher, this.subject) : studentList = [];

  String getClassName() {
    return className;
  }

  List<Student> getStudentList() {
    return studentList;
  }

  Subject getSubject() {
    return subject;
  }

  Teacher getTeacher() {
    return teacher;
  }

  void setTeacher(Teacher newTeacher) {
    teacher = newTeacher;
  }

  void setClassName(String newClassName) {
    className = newClassName;
  }

  void addStudent(Student student) {
    studentList.add(student);
  }

  void removeStudent(Student student) {
    studentList.remove(student);
  }

  List<GradeData> getGradeListForClass(String className,
      {String? assignmentName}) {
    List<GradeData> classGradeList = [];

    for (Student student in studentList) {
      // Filter the grades for the specified class
      List<GradeData> gradesForClass = student.gradeList
          .where((grade) => grade.classObject.className == className)
          .toList();

      if (assignmentName != null) {
        // If assignmentName is provided, further filter for the specified assignment
        gradesForClass = gradesForClass
            .where((grade) => grade.assignmentName == assignmentName)
            .toList();
      }

      // Add the filtered grades to the classGradeList
      classGradeList.addAll(gradesForClass);
    }

    return classGradeList;
  }
}
