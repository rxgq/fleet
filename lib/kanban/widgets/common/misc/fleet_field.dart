import 'package:flutter/material.dart';

class FleetField extends StatefulWidget {
  const FleetField({
    super.key, 
    required this.onClickOff,
    required this.controller,
    this.isSubmittable = false,
    this.obscure = false
  });

  final TextEditingController controller;
  final VoidCallback onClickOff;
  final bool isSubmittable;
  final bool obscure;

  @override
  State<FleetField> createState() => _FleetFieldState();
}

class _FleetFieldState extends State<FleetField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && !widget.isSubmittable) {
        widget.onClickOff();
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
        obscureText: widget.obscure,
        focusNode: _focusNode,
        style: const TextStyle(
          color: Color.fromARGB(255, 92, 92, 92),
          fontSize: 14,
          fontFamily: "Inter",
          fontWeight: FontWeight.w500
        ),
        controller: widget.controller,
        onSubmitted: (_) {
          widget.onClickOff();
        },
        textAlignVertical: TextAlignVertical.top,
        maxLines: widget.isSubmittable ? 1 : null,
        expands: widget.isSubmittable ? false : true,
        cursorColor: const Color.fromARGB(255, 195, 195, 195),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
