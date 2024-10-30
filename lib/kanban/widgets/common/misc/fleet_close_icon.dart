import 'package:flutter/material.dart';

class FleetCloseIcon extends StatelessWidget {
  const FleetCloseIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Padding(
          padding: EdgeInsets.only(top: 10, right: 8, left: 8),
          child: Icon(
            Icons.close,
            color: Colors.grey,
            size: 18,
          ),
        ),
      ),
    );
  }
}