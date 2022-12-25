import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String userId;
  final String text;
  final bool isDone;

  const Todo({
    required this.id,
    required this.userId,
    required this.text,
    required this.isDone,
  });
}
