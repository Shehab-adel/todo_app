import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task {
  final String? id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;
  final String userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
    DateTime? createdAt,
    String? userId, // اختياري
  })  : createdAt = createdAt ?? DateTime.now(),
        userId = userId ?? FirebaseAuth.instance.currentUser?.uid ?? '';

  // Convert Task to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  // Create Task from Firestore document
  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dueDate'])
          : null,
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  // Create Task from Firestore DocumentSnapshot
  factory Task.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Task.fromMap(data, snapshot.id);
  }

  // Create a copy of the task with updated fields
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
