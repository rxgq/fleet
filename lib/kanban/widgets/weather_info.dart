import 'package:fleet/kanban/services/weather/models/weather_model.dart';
import 'package:flutter/material.dart';

class WeatherInfo extends StatefulWidget {
  const WeatherInfo({
    super.key, 
    required this.model
  });

  final WeatherModel model;

  @override
  State<WeatherInfo> createState() => _WeatherInfoState();
}

class _WeatherInfoState extends State<WeatherInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            widget.model.description,
            style: const TextStyle(
              color: Color.fromARGB(255, 69, 69, 69),
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
        ),
        Text(
          "${widget.model.temperature}°C",
          style: const TextStyle(
              color: Color.fromARGB(255, 69, 69, 69),
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
        )
      ],
    );
  }
}