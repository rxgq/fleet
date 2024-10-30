import 'package:fleet/constants.dart';
import 'package:fleet/kanban/widgets/common/fleet_text.dart';
import 'package:flutter/material.dart';

class TaskBar extends StatefulWidget {
  const TaskBar({super.key});

  @override
  State<TaskBar> createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 40,
      decoration: const BoxDecoration(
        color: constGrey
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: FleetText(
          text: "good morning.", 
          size: 14,
          colour: Colors.grey,
          weight: FontWeight.w300,
        ),
      ),
    );
  }
}