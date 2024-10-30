import 'package:fleet/kanban/models/task_model.dart';
import 'package:fleet/kanban/services/database_service.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_dropdown.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:fleet/kanban/widgets/common/misc/kanban_field.dart';
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

              _description(),
              _projectDropdown()
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FleetText(
        text: widget.model.title,
        size: 20,
        weight: FontWeight.w300,
        colour: Colors.grey,
      ),
    );
  }

  Widget _status() {
    return Padding(
      padding: const EdgeInsets.only(right: 12, top: 8),
      child: FleetText(
        text: widget.model.status,
        size: 16,
        colour: Colors.grey,
        weight: FontWeight.w100,
      ),
    );
  }

  Widget _description() {
    return SizedBox(
      width: 480, height: 160,
      child: KanbanField(
        onSubmit: () async {
          await _db.updateDescription(widget.model, _descriptionController.text);
        }, 
        controller: _descriptionController
      ),
    );
  }

  Widget _projectDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FleetDropdown(
        items: const ["Web Applications", "Object Oriented", "Action Enquiry"], 
        onChange: (item) {
      
        }
      ),
    );
  }
}