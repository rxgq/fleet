import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/db.dart';
import 'package:fleet/kanban/widgets/add_task/add_task_button.dart';
import 'package:fleet/kanban/widgets/add_task/add_task_field.dart';
import 'package:fleet/kanban/widgets/kanban_dialogue.dart';
import 'package:fleet/kanban/widgets/task_screen.dart';
import 'package:fleet/kanban/widgets/task_card.dart';
import 'package:flutter/material.dart';

class TaskColumn extends StatefulWidget {
  const TaskColumn({
    super.key,
    required this.model,
    required this.onUpdate,
  });

  final TaskColumnModel model;
  final VoidCallback onUpdate;

  @override
  State<TaskColumn> createState() => TaskColumnState();
}

class TaskColumnState extends State<TaskColumn> {
  final _db = DatabaseService();

  bool _isHovering = false;
  bool _isHoveringTitle = false;
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
              width: 240,
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 243, 243),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var task in widget.model.tasks) _buildTask(task),

                          if (_isHovering && !_isAddingTask)
                            AddTaskButton(
                              onTap: () {
                                setState(() {
                                  _isAddingTask = true;
                                });
                              },
                            ),

                          if (_isAddingTask)
                            AddTaskField(
                              controller: _taskTitleController,
                              onEnter: () async {
                                _isAddingTask = false;
                                
                                await _db.createTask(_taskTitleController.text, widget.model);
                                _taskTitleController.clear();

                                widget.onUpdate();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle() {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHoveringTitle = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHoveringTitle = false;
        });
      },
      child: SizedBox(
        width: 240,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 160,
                child: Text(
                  widget.model.title,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 36, 36, 36)
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const Spacer(),
            if (_isHoveringTitle) MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (_) {
                    return KanbanDialog(message: "delete column '${widget.model.title}'?", onClick: (option) async {
                      if (option == "yes") {
                        await _db.deleteColumn(widget.model);
                        widget.onUpdate();
                      }
                    });
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.delete,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (_isHoveringTitle) MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ) 
          ],
        ),
      ),
    );
  }

  Widget _buildTask(TaskModel task) {
    return TaskCard(
      onUpdate: () {
        widget.onUpdate();
      },
      model: task,
      onMenuTap: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return TaskScreen(model: task);
          },
        );

        await _db.refreshBoard();
        setState(() {
          widget.onUpdate();
        });
      },
    );
  }
}
