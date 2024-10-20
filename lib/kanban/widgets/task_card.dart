import 'package:fleet/kanban/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, 
    required this.model, 
    required this.onMenuTap
  });

  final TaskModel model;
  final VoidCallback onMenuTap;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Draggable<TaskModel>(
            feedback: _buildTaskDragging(constraints),
            data: widget.model,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            if (_isHovering) _buildInfoIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDragging(BoxConstraints constraints) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
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
}
