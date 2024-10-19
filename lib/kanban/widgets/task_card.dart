import 'package:fleet/kanban/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, 
    required this.model
  });

  final TaskModel model;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Draggable<TaskModel>(
          feedback: Material(
            elevation: 6.0,
            child: Container(
              width: constraints.maxWidth, 
              height: 90,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.model.title,
                  style: const TextStyle(
                    fontSize: 14
                  ),
                ),
              ),
            ),
          ),
          data: widget.model,
          child: Container(
            width: constraints.maxWidth, height: 90,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.title,
                style: const TextStyle(
                  fontSize: 14
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}


}