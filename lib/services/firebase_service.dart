import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _tasksCollection = 'tasks';

  // Add a new task to Firestore
  static Future<String?> addTask(Task task) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_tasksCollection)
          .add(task.toMap());
      return docRef.id;
    } catch (e) {
      print('Error adding task: $e');
      return null;
    }
  }

  // Get all tasks from Firestore
  static Future<List<Task>> getTasks() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_tasksCollection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Task.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print('Error getting tasks: $e');
      return [];
    }
  }

  // Update a task in Firestore
  static Future<bool> updateTask(String taskId, Task task) async {
    try {
      await _firestore
          .collection(_tasksCollection)
          .doc(taskId)
          .update(task.toMap());
      return true;
    } catch (e) {
      print('Error updating task: $e');
      return false;
    }
  }

  // Delete a task from Firestore
  static Future<bool> deleteTask(String taskId) async {
    try {
      await _firestore
          .collection(_tasksCollection)
          .doc(taskId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  // Get tasks as a stream for real-time updates
  static Stream<List<Task>> getTasksStream() {
    return _firestore
        .collection(_tasksCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromSnapshot(doc))
            .toList());
  }

  // Mark task as completed/uncompleted
  static Future<bool> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await _firestore
          .collection(_tasksCollection)
          .doc(taskId)
          .update({'isCompleted': isCompleted});
      return true;
    } catch (e) {
      print('Error toggling task completion: $e');
      return false;
    }
  }
}
