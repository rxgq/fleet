import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/database_service.dart';
import 'package:fleet/kanban/widgets/common/kanban_field.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key, 
    required this.model
  });

  final TaskModel model;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _db = DatabaseService();

  final _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.text = widget.model.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 900, height: 420,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(),
                  const Spacer(),
                  _status()
                ],
              ),

              _description()
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        widget.model.title,
        style: const TextStyle(
          fontSize: 20
        ),
      ),
    );
  }

  Widget _status() {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 8),
      child: Text(
        widget.model.status,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey
        ),
      ),
    );
  }

  Widget _description() {
    return SizedBox(
      width: 400, height: 120,
      child: KanbanField(
        onSubmit: () async {
          await _db.updateDescription(widget.model, _descriptionController.text);
        }, 
        controller: _descriptionController
      ),
    );
  }
}