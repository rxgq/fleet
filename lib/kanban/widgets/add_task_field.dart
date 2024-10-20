import 'package:flutter/material.dart';

class AddTaskField extends StatefulWidget {
  const AddTaskField({
    super.key,
    required this.onEnter,
    required this.controller,
  });

  final VoidCallback onEnter;
  final TextEditingController controller;

  @override
  State<AddTaskField> createState() => _AddTaskFieldState();
}

class _AddTaskFieldState extends State<AddTaskField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 92, 92, 92),
          fontSize: 14
        ),
        controller: widget.controller,
        autofocus: true,
        onSubmitted: (_) {
          widget.onEnter();
        },
        cursorColor: const Color.fromARGB(255, 92, 92, 92),
        decoration: InputDecoration(
          hoverColor: Colors.white,
          filled: true,
          fillColor: Colors.white,
          hintText: 'new task...',
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 206, 206, 206),
            fontSize: 14
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ),
      ),
    );
  }
}
