import 'package:fleet/kanban/services/db.dart';
import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/widgets/task_column.dart';
import 'package:flutter/material.dart';

class BoardView extends StatefulWidget {
  const BoardView({
    super.key, 
  });

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final _board = BoardController();
  final _db = DatabaseService();

  @override
  void initState() {
    _initBoard();
    super.initState();
  }

  Future _initBoard() async {
    final columns = await _db.getColumns();
    _board.setColumns(columns);

    final tasks = await _db.getTasks();
    _board.addTasks(tasks);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          for (var col in _board.columns)
            TaskColumn(model: col, onUpdate: () {
              setState(() {});
            })
        ],
      )
    );
  }
}