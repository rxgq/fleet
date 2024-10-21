import 'package:flutter/material.dart';

class AddColumnField extends StatefulWidget {
  const AddColumnField({
    super.key, 
    required this.onEnter,
    required this.controller
  });

  final VoidCallback onEnter;
  final TextEditingController controller;

  @override
  State<AddColumnField> createState() => _AddColumnFieldState();
}

class _AddColumnFieldState extends State<AddColumnField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 180, height: 50,
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
            hintText: 'new column...',
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
      ),
    );
  }
}