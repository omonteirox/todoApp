import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:task_list_app/models/task.dart';

class TodoListItem extends StatefulWidget {
  TodoListItem(
      {super.key,
      required this.task,
      required this.onDelete,
      required this.ontaskCompleted});
  final Task task;
  final Function(Task) onDelete;
  final Function(bool) ontaskCompleted;
  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  bool isChecked = false;
  final df = DateFormat('dd/MM/yyyy - HH:mm');
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: "Deletar",
              flex: 1,
              onPressed: (context) {
                widget.onDelete(widget.task);
              },
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.red,
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color.fromARGB(255, 214, 214, 214)),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    curve: Curves.linear,
                    softWrap: true,
                    style: isChecked
                        ? const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(250, 0, 189, 179),
                            decoration: TextDecoration.lineThrough)
                        : const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      df.format(widget.task.date),
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    curve: Curves.linear,
                    softWrap: true,
                    style: isChecked
                        ? const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(250, 0, 189, 179),
                            decoration: TextDecoration.lineThrough)
                        : const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none),
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      widget.task.taskName,
                    ),
                  ),
                ],
              ),
              Checkbox(
                checkColor: Colors.white,
                activeColor: const Color.fromARGB(250, 0, 189, 179),
                value: isChecked,
                onChanged: (value) {
                  isChecked = !isChecked;
                  widget.ontaskCompleted(isChecked);
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
