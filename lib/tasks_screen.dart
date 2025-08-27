import "package:flutter/material.dart";
import 'package:todo_app/models/task.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/services/firebase_services.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blue Add Task button
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.43,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.addNewTaskScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 30),
                    SizedBox(width: 20),
                    Text(
                      'Add Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 Task List from Firestore
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: FirebaseServices.getTasksStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No tasks yet. Add some!"));
                  }

                  final tasks = snapshot.data!;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            // Texts (title + description + due date)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (task.dueDate != null)
                                    Text(
                                      task.dueDate!
                                          .toLocal()
                                          .toString()
                                          .split(" ")[0],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // ✅ Done/Not Done toggle
                            InkWell(
                              onTap: () async {
                                await FirebaseServices.toggleTaskCompletion(
                                  task.id!, // Task ID from Firestore
                                  !task.isCompleted, // Flip the state
                                );
                              },
                              child: Icon(
                                task.isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: task.isCompleted
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // 🗑️ Delete button
                            InkWell(
                              onTap: () async {
                                await FirebaseServices.deleteTask(task.id!);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
