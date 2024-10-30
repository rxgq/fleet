import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';

class FleetButton extends StatefulWidget {
  const FleetButton({super.key, required this.onClick, required this.text});

  final String text;
  final VoidCallback onClick;

  @override
  State<FleetButton> createState() => _FleetButtonState();
}

class _FleetButtonState extends State<FleetButton> {
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
            height: 30,
            decoration: BoxDecoration(
              color: buttonGrey,
              borderRadius: BorderRadius.circular(2)
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FleetText(
                  text: widget.text, 
                  size: 14, 
                  weight: FontWeight.w500, 
                  colour: Colors.grey
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}