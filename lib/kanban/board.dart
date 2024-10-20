import 'package:fleet/kanban/services/db.dart';
import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/services/weather/models/weather_model.dart';
import 'package:fleet/kanban/services/weather/utils/weather_service.dart';
import 'package:fleet/kanban/widgets/task_column.dart';
import 'package:fleet/kanban/widgets/weather_info.dart';
import 'package:flutter/material.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key, 
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final _db = DatabaseService();
  final _board = BoardController();
  final _weather = WeatherService();

  WeatherModel? weather;
  bool _isLoading = true;

  @override
  void initState() {
    _initBoard();
    super.initState();
  }

  Future _initBoard() async {
    weather = await _weather.getWeather();

    final columns = await _db.getColumns();
    _board.setColumns(columns);

    final tasks = await _db.getTasks();
    _board.addTasks(tasks);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _columns(),
          const Spacer(),
          if (!_isLoading) WeatherInfo(model: weather!),
        ],
      )
    );
  }

  Widget _columns() {
    return Row(
      children: [
        for (var col in _board.columns)
          TaskColumn(model: col, onUpdate: () async {
            await _db.refreshBoard();
            setState(() {});
          })
      ],
    );
  }
}