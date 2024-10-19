import 'package:flutter/material.dart';

class AddTaskButton extends StatefulWidget {
  const AddTaskButton({
    super.key,
    required this.onTap
  });

  final VoidCallback onTap;

  @override
  State<AddTaskButton> createState() => _AddTaskButtonState();
}

class _AddTaskButtonState extends State<AddTaskButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: constraints.maxWidth, height: 30,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 226, 226),
              borderRadius: BorderRadius.circular(2)
            ),
            child: Row(
              children: [
                _addTaskIcon()
              ],
            ),
          ),
        );
      } 
    );
  }

  Widget _addTaskIcon() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(
            Icons.add,
            size: 18,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}