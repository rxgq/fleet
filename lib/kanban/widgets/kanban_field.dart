import 'package:flutter/material.dart';

class KanbanField extends StatefulWidget {
  const KanbanField({
    super.key, 
    required this.onSubmit,
    required this.controller,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  State<KanbanField> createState() => _KanbanFieldState();
}

class _KanbanFieldState extends State<KanbanField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.onSubmit();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        focusNode: _focusNode,
        style: const TextStyle(
          color: Color.fromARGB(255, 92, 92, 92),
        ),
        controller: widget.controller,
        onSubmitted: (_) {
          widget.onSubmit();
        },
        textAlignVertical: TextAlignVertical.top,
        maxLines: null,
        expands: true,
        cursorColor: const Color.fromARGB(255, 195, 195, 195),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 206, 206, 206),
            fontSize: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 230, 230, 230),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(2),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 200, 200, 200),
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0, 
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}
