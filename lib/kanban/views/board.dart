import 'package:fleet/kanban/services/database_service.dart';
import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/widgets/add_column/add_column_field.dart';
import 'package:fleet/kanban/widgets/common/task_bar.dart';
import 'package:fleet/kanban/widgets/common/task_column.dart';
import 'package:fleet/kanban/widgets/weather/weather_info.dart';
import 'package:flutter/material.dart';
import '../services/weather/models/weather_model.dart';
import '../services/weather/utils/weather_service.dart';
import '../widgets/add_column/add_column_button.dart';

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
  final _wt = WeatherService();

  WeatherModel? _weather;
  bool _isLoading = true;

  final _columnTitleController = TextEditingController();
  bool _isAddingColumn = false;

  @override
  void initState() {
    _initBoard();
    super.initState();
  }

  Future _initBoard() async {
    _weather = await _wt.getWeather();
    await _db.refreshBoard();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: !_isLoading ? Column(
        children: [
          const TaskBar(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _columns(),
              _addColumnButton(),
          
              const Spacer(),
              WeatherInfo(model: _weather!),
            ],
          ),
        ],
      ) : const SizedBox()
    );
  }

  Widget _addColumnButton() {
    return !_isAddingColumn ? AddColumnButton(
      onClick: () {
        setState(() {
          _isAddingColumn = true;
        });
      }
    ) : AddColumnField(
      onEnter: () async {
        await _db.createColumn(_columnTitleController.text);
        _columnTitleController.clear();
        _isAddingColumn = false;

        setState(() {});
      }, 
      controller: _columnTitleController
    );
  }

  Widget _columns() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width - 340,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var col in _board.columns)
              TaskColumn(
                model: col,
                onUpdate: () async {
                  await _db.refreshBoard();
                  setState(() {});
                }
              ),
          ],
        ),
      ),
    );
  }
}