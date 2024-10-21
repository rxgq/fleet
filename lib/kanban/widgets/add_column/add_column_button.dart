import 'package:flutter/material.dart';

class AddColumnButton extends StatefulWidget {
  const AddColumnButton({
    super.key, 
    required this.onClick
  });

  final VoidCallback onClick;

  @override
  State<AddColumnButton> createState() => _AddColumnButtonState();
}

class _AddColumnButtonState extends State<AddColumnButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onClick();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 243, 243),
              borderRadius: BorderRadius.circular(2)
            ),
            child: const Icon(
              Icons.add,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}