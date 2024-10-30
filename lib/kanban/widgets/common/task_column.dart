import 'package:fleet/kanban/models/task_column_model.dart';
import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/database_service.dart';
import 'package:fleet/kanban/widgets/add_task/add_task_button.dart';
import 'package:fleet/kanban/widgets/add_task/add_task_field.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_dialogue.dart';
import 'package:fleet/kanban/widgets/common/task_screen.dart';
import 'package:fleet/kanban/widgets/common/task_card.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

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
  bool _isEditingColumn = false;

  final _taskTitleController = TextEditingController();
  final _columnTitleController = TextEditingController();

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
              height: MediaQuery.sizeOf(context).height - 60,
              decoration: BoxDecoration(
                color: constGrey,
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
            !_isEditingColumn ? _columnTitle() : _buildColumnTitleField(),
            const Spacer(),
            if (_isHoveringTitle) MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  showDialog(context: context, builder: (_) {
                    final subMsg = "the ${widget.model.tasks.length} task(s) in this column will also be deleted";

                    return FleetDialog(
                      message: "delete column '${widget.model.title}'?\n${widget.model.tasks.isNotEmpty ? subMsg : ""}", 
                      onClick: (final option) async {
                        if (option == "no") return;
      

                        for (var task in widget.model.tasks) {
                          await _db.deleteTask(task);
                        }

                        await _db.deleteColumn(widget.model);

                        widget.onUpdate();
                      }
                    );
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
                onTap: () {
                  setState(() {
                    _isEditingColumn = true;
                    _columnTitleController.text = widget.model.title;
                  });
                },
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

  Widget _columnTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 160,
        child: Row(
          children: [
            FleetText(
              text: widget.model.title,
              size: 14,
              colour: const Color.fromARGB(255, 110, 110, 110),
              weight: FontWeight.w500,
            ),
            const SizedBox(width: 8),
            FleetText(
              text: "${widget.model.tasks.length}",
              size: 14,
              colour: const Color.fromARGB(255, 110, 110, 110),
              weight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnTitleField() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 140, height: 30,
        child: TextField(
          style: const TextStyle(
            color: Color.fromARGB(255, 92, 92, 92),
            fontSize: 14
          ),
          controller: _columnTitleController,
          autofocus: true,
          onSubmitted: (_) async {
            await _db.updateColumnTitle(widget.model, _columnTitleController.text);
            widget.onUpdate();
            _isEditingColumn = false;
          },
          cursorColor: const Color.fromARGB(255, 92, 92, 92),
          decoration: InputDecoration(
            hoverColor: Colors.white,
            filled: true,
            fillColor: Colors.white,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 206, 206, 206),
              fontSize: 14
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
          ),
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
