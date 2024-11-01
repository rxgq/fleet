import 'package:fleet/kanban/controllers/board_controller.dart';
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
      "cls"  => cls(argc, argv),
      "crp"  => crp(argc, argv),
      // "crt"  => crt(argc, argv),
      // "crc"  => crc(argc, argv),
      // "rmt"  => rmt(argc, argv),
      // "rmc"  => rmc(argc, argv),
      // "mov"  => mov(argc, argv),

      "echo"   => echo(argc, argv),
      "cowsay" => cowsay(argc, argv),

      "help" => help(),
      _ => null,
    };
  }

  void help() {
    write("cls          clears the console");
    write("echo         writes back the users input");
    
    write("crt <1> <2>  creates a task in a column");
    write("crc <1>      creates a column");
    write("rmt <1>      deletes a task");
    write("rmc <1>      deletes a column");
    write("mov <1> <2>  moves a task to another column");
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

  Future crp(int argc, List<String> argv) async {
    if (argc != 2) {
      write("crp takes one argument <project>");
      return;
    }

    var project = argv[1];
    await _db.createProject(project);
    await _db.refreshBoard();
  }

    Future rmp(int argc, List<String> argv) async {
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
}