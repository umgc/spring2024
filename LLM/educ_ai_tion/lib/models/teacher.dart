import 'class_data.dart';

// Teacher Class
class Teacher {
  // Attributes
  String firstName;
  String lastName;
  String email; //primary key
  List<ClassData> classList;

  // Constructor
  Teacher(this.firstName, this.lastName, this.email) : classList = [];

  void addClass(String className) {
    // todo: Implementation
  }

  void removeClass(String className) {
    // todo: Implementation
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
