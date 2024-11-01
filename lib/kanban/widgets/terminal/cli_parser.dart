import 'package:flutter/material.dart';

final class CliParser {
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

  // Future crt(int argc, List<String> argv) async {
  //   if (argc != 3) {
  //     write("crt takes 2 arguments: crt <task> <column>");
  //     return;
  //   }

  //   var column = tryGetColumn(argv[2]);
  //   if (column == null) return;

  //   var board = Provider.of<BoardProvider>(context, listen: false);
  //   await board.createTask(argv[1], argv[2]);
  // }

  // Future crc(int argc, List<String> argv) async {
  //   if (argc != 2) {
  //     write("crc takes 1 argument: crc <column>");
  //     return;
  //   }

  //   var board = Provider.of<BoardProvider>(context, listen: false);
  //   await board.createColumn(argv[1]);
  // }

  // Future rmt(int argc, List<String> argv) async {
  //   if (argc != 2) {
  //     write("rmt takes 1 argument: rmt <task>");
  //     return;
  //   }

  //   var task = tryGetTask(argv[1]);
  //   if (task == null) return;

  //   var board = Provider.of<BoardProvider>(context, listen: false);
  //   await board.deleteTask(task);
  // }
  
  // Future rmc(int argc, List<String> argv) async {
  //   if (argc != 2) {
  //     write("rmc takes 1 argument: rmc <column>");
  //     return;
  //   }

  //   var column = tryGetColumn(argv[1]);
  //   if (column == null) return;

  //   var board = Provider.of<BoardProvider>(context, listen: false);
  //   await board.deleteColumn(column);
  // }

  // Future mov(int argc, List<String> argv) async {
  //   if (argc != 3) {
  //     write("mv takes 2 arguments: mv <task> <column>");
  //     return;
  //   }

  //   var card = tryGetTask(argv[1]);
  //   if (card == null) return;

  //   var column = tryGetColumn(argv[2]);
  //   if (column == null) return;

  //   var board = Provider.of<BoardProvider>(context, listen: false);
  //   await board.moveTask(card, column.title);
  // }


  // ColumnModel? tryGetColumn(String title) {
  //   var board = Provider.of<BoardProvider>(context, listen: false);

  //   var column = board.getColumn(title);
  //   if (column == null) {
  //     write("column '$title' not found");
  //     return null;
  //   }

  //   return column;
  // }

  // TaskModel? tryGetTask(String header) {
  //   var board = Provider.of<BoardProvider>(context, listen: false);

  //   var task = board.getTask(header);
  //   if (task == null) {
  //     write("task '$header' not found");
  //     return null;
  //   }

  //   return task;
  // }
}