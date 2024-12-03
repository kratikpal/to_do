import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/models/task_model.dart';
import 'package:to_do/provider/task_provider.dart';
import 'package:to_do/widgets/task_tile.dart';
import 'package:provider/provider.dart'; // Import the provider package
import '../constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load tasks when the app starts
    Future.delayed(Duration.zero, () {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final taskController = TextEditingController();

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: IconButton(
              onPressed: taskProvider.getTaskFromAPI,
              icon: const Icon(
                Icons.download,
                color: tdBlack,
              ),
            ),
            onPressed: () => _showAddTaskDialog(context, taskProvider),
          ),
        ],
        title: const Text(
          "To Do",
          style: TextStyle(color: tdBlack),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(taskProvider),
                const SizedBox(height: 20),
                Expanded(
                  child: taskProvider.getTasks.isNotEmpty
                      ? ListView.builder(
                          itemCount: taskProvider.getTasks.length,
                          itemBuilder: (context, index) {
                            final task = taskProvider.getTasks[index];
                            return TaskTile(
                              todo: task,
                              onToDoChanged: taskProvider.updateTask,
                              onDeleteItem: taskProvider.removeTask,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            "No tasks found",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (taskProvider.isLoading) ...[
            const Opacity(
              opacity: 0.7,
              child: ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ]
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tdBlue,
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context, taskProvider),
      ),
    );
  }

  // Refactor the searchBox to use provider
  Widget searchBox(TaskProvider taskProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => taskProvider.searchTask(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, TaskProvider taskProvider) {
    final TextEditingController titleController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: selectedDate == null
                              ? 'Select Due Date'
                              : 'Due Date: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        selectedDate != null) {
                      taskProvider.addTask(
                        TaskModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: titleController.text,
                          dueDate: selectedDate!,
                          isDone: false,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add Task'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
