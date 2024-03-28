// Users Data Model
//
// Represents the data model for the users that is stored on Firestore.
import 'package:flutter/material.dart';
import 'roles_enum.dart';

class Users {
  final String email;
  final Roles_Enum role;
  bool signedUp;
  Users({
    required this.email,
    required this.role,
    required this.signedUp,
  });
}
