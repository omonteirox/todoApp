import 'package:flutter/material.dart';
import 'package:task_list_app/models/task.dart';
import 'package:task_list_app/repository/task_repository.dart';

import '../widgets/todo_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController taskController = TextEditingController();
  final TaskRepository taskRepository = TaskRepository();
  int? deletedIndex;
  Task? deletedTask;
  String? errorText;
  @override
  List<Task> tasks = [];
  void initState() {
    super.initState();
    taskRepository.getTodoList().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(250, 0, 189, 179),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(250, 0, 189, 179))),
                          errorText: errorText,
                          labelText: "Insira uma tarefa",
                          hintText: "Ex. Fazer tarefa de matemática",
                          border: const OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          saveTask();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: saveTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(250, 0, 189, 179),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Flexible(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return TodoListItem(
                        task: tasks[index],
                        onDelete: onDelete,
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Você possui ${tasks.length} tarefas pendentes')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeletedTasksConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(250, 0, 189, 179),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'Limpar Tudo',
                        style: TextStyle(
                          backgroundColor: Color.fromARGB(250, 0, 189, 179),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveTask() {
    String text = taskController.text;
    DateTime date = DateTime.now();
    taskController.clear;
    taskController.text = "";
    Task newTask = Task(taskName: text, date: date);
    taskRepository.saveTodoList(tasks);
    if (text.isEmpty) {
      errorText = "Insira alguma tarefa";
      setState(() {});
      return;
    }
    setState(() {
      tasks.add(newTask);
      errorText = null;
    });
  }

  void showDeletedTasksConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar Tudo?"),
        content:
            const Text("Você tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () {
              tasks.clear();
              taskRepository.saveTodoList(tasks);
              setState(() {});
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Apagar Tudo",
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              taskRepository.saveTodoList(tasks);
            },
            style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(250, 0, 189, 179)),
            child:
                const Text("Cancelar", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void onDelete(Task task) {
    deletedTask = task;
    deletedIndex = tasks.indexOf(task);
    tasks.remove(task);
    setState(() {});
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Tarefa ${task.taskName} foi removida com êxito"),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Desfazer',
          onPressed: () {
            tasks.insert(deletedIndex!, deletedTask!);
            setState(() {});
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
    taskRepository.saveTodoList(tasks);
  }
}
