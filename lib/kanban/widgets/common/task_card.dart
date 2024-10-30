import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/database_service.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:fleet/kanban/widgets/common/misc/kanban_dialogue.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, 
    required this.model, 
    required this.onMenuTap,
    required this.onUpdate,
  });

  final TaskModel model;
  final VoidCallback onMenuTap;
  final VoidCallback onUpdate;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final _db = DatabaseService();
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Draggable<TaskModel>(
            data: widget.model,
            childWhenDragging: _buildTaskDragging(constraints),
            feedback: _buildTaskFeedback(constraints),
            child: _buildTask(constraints),
          );
        },
      ),
    );
  }

  Widget _buildTask(BoxConstraints constraints) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        width: constraints.maxWidth,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskTitle(constraints),
            const Spacer(),
            Column(
              children: [
                if (_isHovering) _buildInfoIcon(),
                const Spacer(),
                if (_isHovering) _buildDeleteIcon(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDragging(BoxConstraints constraints) {
    return Material(
      elevation: 2,
      child: Container(
        width: constraints.maxWidth,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskTitle(constraints)
          ],
        ),
      ),
    );
  }

  Widget _buildTaskFeedback(BoxConstraints constraints) {
    return Material(
      elevation: 8,
      child: Container(
        width: constraints.maxWidth,
        height: 90,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _taskTitle(constraints)
          ],
        ),
      ),
    );
  }

  Widget _taskTitle(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: constraints.maxWidth - 50,
        child: FleetText(
          text: widget.model.title,
          size: 14,
          colour: Colors.grey,
          weight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildInfoIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            widget.onMenuTap();
          },
          child: const Icon(
            Icons.menu,
            size: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () async {
            showDialog(context: context, builder: (context) {
              var taskTitle = widget.model.title;
              if (taskTitle.length > 30) taskTitle = widget.model.title.substring(0, 30);

              return KanbanDialog(message: "delete task '$taskTitle'?", onClick: (option) async {
                if (option == "no") return;

                await _db.deleteTask(widget.model);
                widget.onUpdate();
              });
            });
          },
          child: const Icon(
            Icons.delete,
            size: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
