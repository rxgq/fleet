import 'package:fleet/constants.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
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
        padding: EdgeInsets.only(left: 24, top: 10),
        child: FleetText(
          text: "good morning.", 
          size: 14,
          colour: Colors.grey,
          weight: FontWeight.w500,
        ),
      ),
    );
  }
}