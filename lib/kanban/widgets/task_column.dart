import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/db.dart';
import 'package:fleet/kanban/widgets/add_task_button.dart';
import 'package:fleet/kanban/widgets/add_task_field.dart';
import 'package:fleet/kanban/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskColumn extends StatefulWidget {
  const TaskColumn({
    super.key, 
    required this.model,
    required this.onUpdate
  });

  final TaskColumnModel model;
  final VoidCallback onUpdate;

  @override
  State<TaskColumn> createState() => TaskColumnState();
}

class TaskColumnState extends State<TaskColumn> {
  final _db = DatabaseService();

  bool _isHovering = false;
  bool _isAddingTask = false;

  final _taskTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DragTarget(
        onAcceptWithDetails: (details) async {
          final task = details.data as TaskModel;

          if (task.columnId == widget.model.id) return;

          await _db.updateStatus(task, widget.model);
          widget.onUpdate();
        },
        builder: (context, _, __) {
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovering = true;
              });
            },
            onExit: (_) {
              if (_isAddingTask && _taskTitleController.text.isEmpty) _isAddingTask = false;

              setState(() {
                _isHovering = false;
              });
            },
            child: Container(
              width: 240, height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                color:  const Color.fromARGB(255, 243, 243, 243),
                borderRadius: BorderRadius.circular(2)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    TaskCard(model: task),

                  if (_isHovering && !_isAddingTask) AddTaskButton(onTap: () {
                    setState(() {
                      _isAddingTask = true;
                    });
                  }),

                  if (_isAddingTask) AddTaskField(
                    controller: _taskTitleController,
                    onEnter: () async {
                    _isAddingTask = false;
                    _isHovering = false;

                    await _db.createTask(_taskTitleController.text, widget.model);
                    widget.onUpdate();
                  })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}