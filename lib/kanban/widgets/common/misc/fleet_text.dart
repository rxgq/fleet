import 'package:flutter/material.dart';

class FleetText extends StatelessWidget {
  const FleetText({
    super.key,
    required this.text,
    required this.size,
    required this.weight,
    required this.colour,
    this.maxLines = 1
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color colour;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: colour,
        fontWeight: weight,
        fontFamily: "Inter"
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}