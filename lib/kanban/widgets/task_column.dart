import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskColumn extends StatefulWidget {
  const TaskColumn({
    super.key, 
    required this.model
  });

  final TaskColumnModel model;

  @override
  State<TaskColumn> createState() => TaskColumnState();
}

class TaskColumnState extends State<TaskColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200, height: 700,
        decoration: BoxDecoration(
          color:  const Color.fromARGB(255, 243, 243, 243),
          borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 36, 36, 36)
                ),
              ),
            ),
            for (var task in widget.model.tasks)
              TaskCard(model: task)
          ],
        ),
      ),
    );
  }
}