import 'package:fleet/kanban/services/database_service.dart';
import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/services/logger.dart';
import 'package:fleet/kanban/widgets/add_column/add_column_field.dart';
import 'package:fleet/kanban/widgets/add_project/add_project_widget.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_dialogue.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:fleet/kanban/widgets/common/task_bar.dart';
import 'package:fleet/kanban/widgets/common/task_column.dart';
import 'package:fleet/kanban/widgets/cli/fleet_cli.dart';
import 'package:fleet/kanban/widgets/weather/weather_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../globals.dart';
import '../services/weather/models/weather_model.dart';
import '../services/weather/utils/weather_service.dart';
import '../widgets/add_column/add_column_button.dart';
import '../widgets/common/misc/fleet_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key, 
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final _db = DatabaseService();
  final _logger = Logger();
  final _board = BoardController();
  final _wt = WeatherService();

  WeatherModel? _weather;
  bool _isLoading = true;

  final _columnTitleController = TextEditingController();
  bool _isAddingColumn = false;

  final consoleNode = FocusNode();
  final consoleInputNode = FocusNode();
  final commandController = TextEditingController();

  @override
  void initState() {
    RawKeyboard.instance.addListener(_handleKeyEvent);
    consoleNode.requestFocus();
    _initBoard();
    super.initState();
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (!(event is RawKeyDownEvent)) return;

    bool isControlPressed = RawKeyboard.instance.keysPressed.contains(LogicalKeyboardKey.controlLeft);
    bool isBackquotePressed = event.logicalKey == LogicalKeyboardKey.backquote;
    bool isEnterPressed = event.logicalKey == LogicalKeyboardKey.enter;

    if (isControlPressed && isEnterPressed) {
      Navigator.pop(context);
    }

    if (!isControlPressed || !isBackquotePressed) {
      return;
    }

    setState(() {
      showConsole = !showConsole;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showConsole) {
        FocusScope.of(context).requestFocus(consoleInputNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future _initBoard() async {
    _logger.LogEvent("Hello, Sir!");
    await Future.delayed(const Duration(seconds: 1));

    _weather = await _wt.getWeather();
    await _db.refreshBoard();

    setState(() {
      _isLoading = false;
    });
  }

  Widget _loadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FleetText(
            text: "one moment.", 
            size: 18, 
            weight: FontWeight.w300, 
            colour: Colors.grey
          ),
          SizedBox(height: 24),
          SpinKitRipple(
            color: Colors.grey,
            size: 24,
          )
        ],
      ),
    );
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
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _addColumnButton(),
                  _newProjectButton(),
                ],
              ),
          
              const Spacer(),
              WeatherInfo(model: _weather!),
            ],
          ),
          if (showConsole) FleetCli(
            controller: commandController,
            consoleNode: consoleInputNode,
          )
        ],
      ) : _loadingWidget()
    );
  }

  Widget _newProjectButton() {
    return FleetButton(
      onClick: () {
        showDialog(context: context, builder: (_) {
          return FleetDialog(
            displayItem: AddProjectWidget(
              onProjectAdded: (project) async {
                Navigator.pop(context);
                await _db.createProject(project);
                await _db.refreshBoard();
              }
            ),
          );
        });
      }, 
      text: "new project"
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