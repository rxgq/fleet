import 'package:fleet/kanban/widgets/common/misc/fleet_field.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';

class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({super.key, required this.onProjectAdded});

  final Function(String) onProjectAdded;

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: FleetText(
            text: "enter project name", 
            size: 14, 
            weight: FontWeight.w500,
            colour: Colors.grey
          ),
        ),
        SizedBox(
          width: 280, height: 50,
          child: FleetField(
            isSubmittable: true,
            onClickOff: () async {
              widget.onProjectAdded(_controller.text);
            },
            controller: _controller
          ),
        ),
      ],
    );
  }
}