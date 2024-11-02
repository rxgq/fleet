import 'package:fleet/kanban/controllers/board_controller.dart';
import 'package:fleet/kanban/models/task_project_model.dart';
import 'package:fleet/kanban/services/database_service.dart';
import 'package:flutter/material.dart';

final class CliParser {
  final _db = DatabaseService();
  final _board = BoardController();

  List<String> out = [];

  final BuildContext context;

  CliParser({
    required this.context,
  });
  
  void write(String message) {
    out.add(message);
  }

  List<List<String>> parseCommands(String command) {
    List<List<String>> manyCmds = [];

    var commands = command.split("|");

    for (var splitCommand in commands) {
      var trimmedCommand = splitCommand.trim();

      var commandParts = trimmedCommand.split(RegExp(r'\s+'));

      commandParts = commandParts.map((part) => part.replaceAll("_", " ")).toList();
      commandParts.removeWhere((part) => part.isEmpty);

      manyCmds.add(commandParts);
    }

    return manyCmds;
  }

  Future execute(List<String> argv) async {
    int argc = argv.length;

    return switch (argv[0].toLowerCase()) {
      "crp"    => crp(argc, argv),
      "rmp"    => rmp(argc, argv),
      "crt"    => crt(argc, argv),
      "rmt"    => rmt(argc, argv),
      "mov"    => mov(argc, argv),
      "idxc"   => idxc(argc, argv),

      "cls"    => cls(argc, argv),
      "echo"   => echo(argc, argv),
      "cowsay" => cowsay(argc, argv),

      "help"   => help(),
      _        => null,
    };
  }

  void help() {    
    write("crt  <1> <2> <3?> <4?>  creates a task in a column with optional project and position");
    write("crc  <1> <2?>           creates a column with an optional position");
    write("rmt  <1>                deletes a task");
    write("rmc  <1>                deletes a column");
    write("mov  <1> <2>            moves a task to another column");
    write("idxc <1> <2>            updates a column index position");
  }

  Future<void> crp(int argc, List<String> argv) async {
    if (argc != 2) {
      write("crp takes one argument <project>");
      return;
    }

    var project = argv[1];
    await _db.createProject(project);
    await _db.refreshBoard();
  }

    Future<void> rmp(int argc, List<String> argv) async {
    if (argc != 2) {
      write("rmp takes one argument <project>");
      return;
    }

    var projectName = argv[1];

    var project = _board.projects.where((x) => x.title == projectName).firstOrNull;
    if (project == null) return;

    await _db.deleteProject(project);
    await _db.refreshBoard();
  }

  Future<void> crt(int argc, List<String> argv) async {
    if (argv.length != 3 && argv.length != 5) {
      write("crt takes at least 2 arguments <task_name> <column_name>");
      return;
    }

    var column = _board.getColumn(argv[2]);
    if (column == null) {
      write("column '$argv[2]' not found.");
      return;
    }

    TaskProjectModel? project;
    if (argv.length == 4) {
      project = _board.getProject(argv[3]);
      if (project == null) {
        write("project '${argv[3]}' not found.");
        return;
      }
    }

    String? taskName = argv[1];
    await _db.createTask(taskName, column.id);
    var task = _board.getTask(taskName);
    if (task == null) return;

    if (project != null) await _db.updateTaskProject(task, project);
    await _db.refreshBoard();
  }

  Future<void> rmt(int argc, List<String> argv) async {
    if (argv.length != 2) {
      write("rmt takes one argument <task_name>");
      return;
    }

    var task = _board.getTask(argv[1]);
    if (task == null) {
      write("task '${argv[1]}' not found.");
      return;
    }

    await _db.deleteTask(task);
    await _db.refreshBoard();
  }

  Future<void> mov(int argc, List<String> argv) async {
    if (argv.length != 3) {
      write("mov takes two arguments <task_name> <column_name>");
      return;
    }

    var task = _board.getTask(argv[1]);
    if (task == null) {
      write("task '${argv[1]}' not found.");
      return;
    }

    var column = _board.getColumn(argv[2]);
    if (column == null) {
      write("task '${argv[2]}' not found.");
      return;
    }

    await _db.updateTaskStatus(task, column);
    await _db.refreshBoard();
  }

  Future<void> idxc (int argc, List<String> argv) async {
    if (argv.length != 3) {
      write("mov takes two arguments <column_name> <position>");
      return;
    }

    var column = _board.getColumn(argv[1]);
    if (column == null) {
      write("task '${argv[2]}' not found.");
      return;
    }

    await _db.updateColumnPosition(column, int.parse(argv[2]));
    await _db.refreshBoard();
  }
  
  void echo(int argc, List<String> argv) {
    var out = argv.getRange(1, argc).join(" ");
    write(out);
  }

  void cowsay(int argc, List<String> argv) {
    if (argc < 2) {
      write("provide text for the cow to say");
      return;
    }

    var textToSay = argv.getRange(1, argc).join(" ");

    int textLength = textToSay.length;

    var border = "-" * (textLength + 1);
    var underline = "_" * (textLength + 1);

    var cow = """
        $underline
      < $textToSay >
        $border
                \\   ^__^
                  \\ (oo)\\_______
                    (__)\\       )\\/\\
                        ||----w |
                        ||     ||
    """;

    write(cow);
  }

  void cls(int argc, List<String> argv) {
    if (argc != 1) {
      write("cls takes no arguments");
      return;
    }

    out.clear();
  }
}