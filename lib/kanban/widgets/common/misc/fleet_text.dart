import 'package:flutter/material.dart';

class FleetText extends StatelessWidget {
  const FleetText({
    super.key, 
    required this.text, 
    required this.size, 
    required this.weight, 
    required this.colour
  });

  final String text;
  final double size;
  final FontWeight weight;
  final Color colour;

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
      maxLines: 1,
    );
  }
}