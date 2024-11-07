import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fleet/globals.dart';
import 'package:flutter/material.dart';

import 'cli_parser.dart';

final class FleetCli extends StatefulWidget {
  const FleetCli({
    super.key, 
    required this.controller, 
    required this.consoleNode,
  });

  final TextEditingController controller;
  final FocusNode consoleNode;

  @override
  State<FleetCli> createState() => _FleetCliState();
}

class _FleetCliState extends State<FleetCli> {
  late final CliParser cli;

  @override
  void initState() {
    super.initState();
    cli = CliParser(context: context);
  }

  // Handle key events for command history navigation
  KeyEventResult _handleKeyEvent(FocusNode node, RawKeyEvent event) {
    if (cli.commandHistory.isEmpty) return KeyEventResult.ignored;

    if (event is RawKeyDownEvent) return KeyEventResult.ignored;

    if (event.physicalKey == PhysicalKeyboardKey.arrowUp) {
      // Navigate up in history
      if (cli.commandHistoryIndex == -1) {
        // Start from the most recent command
        cli.commandHistoryIndex = cli.commandHistory.length - 1;
      } else if (cli.commandHistoryIndex > 0) {
        cli.commandHistoryIndex--;
      }

    } else if (event.physicalKey == PhysicalKeyboardKey.arrowDown) {
      // Navigate down in history
      if (cli.commandHistoryIndex < cli.commandHistory.length - 1) {
        cli.commandHistoryIndex++;
      } else {
        cli.commandHistoryIndex = -1; // End of history
      }
    } else {
      return KeyEventResult.ignored;
    }

    // Update the text field with the selected command from history
    widget.controller.text = cli.commandHistoryIndex == -1
        ? '' // Clear if no history item is selected
        : cli.commandHistory[cli.commandHistoryIndex];
    return KeyEventResult.handled;
  }

  Future<void> execute(String command) async {
    setState(() {
      cli.write('> $command');
    });

    var commands = cli.parseCommands(command);

    for (var cmd in commands) {
      await cli.execute(cmd);
    }

    widget.controller.clear();
    widget.consoleNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: consoleHeight,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cli.out.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    cli.out[index],
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "~ fleet/ashton>",
                  style: GoogleFonts.spaceMono(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: Focus(
                  onKey: _handleKeyEvent,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: widget.consoleNode,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    cursorColor: Colors.white,
                    onChanged: (text) {
                      if (text.isEmpty) {
                        cli.commandHistoryIndex = -1; // Clear index when typing new command
                      }

                      setState(() {
                        var commands = cli.parseCommands(text);
                        for (var command in commands) {
                          cli.autoCompleteTask(command);
                        }
                      });
                    },
                    onSubmitted: (String command) async {
                      cli.commandHistory.add(command);
                      await execute(command);
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
