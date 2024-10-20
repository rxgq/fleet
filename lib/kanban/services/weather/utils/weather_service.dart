import 'dart:convert';

import 'package:fleet/kanban/services/weather/models/ip_info_model.dart';
import 'package:fleet/kanban/services/weather/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<IpInfoModel> _getIpInfo() async {
    const url = "https://ipinfo.io/json";

    final result = await http.get(Uri.parse(url));
    final body = jsonDecode(result.body);

    final loc = body['loc'].toString().split(',');
    return IpInfoModel(
      lat: loc[0], 
      lon: loc[1]
    );
  }

  Future<WeatherModel> getWeather() async {
    final ipInfo = await _getIpInfo();

    const baseUrl = "https://api.open-meteo.com/v1/forecast";
    final url = "?latitude=${ipInfo.lat}&longitude=${ipInfo.lon}&current_weather=true";

    final result = await http.get(Uri.parse(baseUrl + url));
    final body = jsonDecode(result.body);

    final weather = body['current_weather'];
    final weatherCode = weather['weathercode'];

    return WeatherModel(
      description: mapWeatherCode(weatherCode),
      temperature: weather['temperature'].toString()
    );
  }

  String mapWeatherCode(int code) {
    return switch (code.toString()) {
      "0"                  => "clear sky",
      "1"  || "2"  || "3"  => "partly cloudy",
      "45" || "48"         => "fog",
      "51" || "53" || "55" => "light drizzle",
      "56" || "57"         => "cold drizzle",
      "61" || "63" || "65" => "rain",
      "66" || "67"         => "freezing rain",
      "71" || "73" || "75" => "snow fall",
      "77"                 => "snow grains",
      "80" || "81" || "82" => "rain showers",
      "85" || "86"         => "snow showers",
      "95"                 => "thunderstorm",
      "96" || "99"         => "thunder with hail",
      _                    => "unknown"
    };
  }
}