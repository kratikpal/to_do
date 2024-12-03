import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/constants/colors.dart';
import 'package:to_do/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel todo;
  final Function(bool, TaskModel) onToDoChanged; // Update the callback type
  final Function(TaskModel) onDeleteItem;

  const TaskTile({
    super.key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              // Pass both `isDone` and `todo` to the callback
              onToDoChanged(!todo.isDone, todo);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.white,
            leading: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: tdBlue,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: tdBlack,
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd/MM/yyyy').format(todo.dueDate),
                  style: const TextStyle(
                    fontSize: 12,
                    color: tdGrey,
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: tdRed,
                borderRadius: BorderRadius.circular(5),
              ),
              child: IconButton(
                color: Colors.white,
                iconSize: 18,
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Call the delete item callback with the task ID
                  onDeleteItem(todo);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
