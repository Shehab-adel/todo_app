import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class FirebaseServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _tasksCollection = 'tasks';

  // Authentication Methods

  // Sign up with email and password
  static Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Check if user is signed in
  static bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  // Handle Firebase Auth exceptions
  static String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An authentication error occurred. Please try again.';
    }
  }

  // Add a new task to Firestore
  static Future<String?> addTask(Task task) async {
    try {
      DocumentReference docRef =
          await _firestore.collection(_tasksCollection).add(task.toMap());
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

      return querySnapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList();
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
      await _firestore.collection(_tasksCollection).doc(taskId).delete();
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
        .map((snapshot) =>
            snapshot.docs.map((doc) => Task.fromSnapshot(doc)).toList());
  }

  // Mark task as completed/uncompleted
  static Future<bool> toggleTaskCompletion(
      String taskId, bool isCompleted) async {
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
