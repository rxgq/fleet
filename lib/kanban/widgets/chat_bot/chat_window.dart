import 'dart:ffi';

import 'package:fleet/globals.dart';
import 'package:fleet/kanban/services/openai/openai_service.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_field.dart';
import 'package:flutter/material.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final _openai = OpenAIService();
  final _chatController = TextEditingController();
  List<String> userChats = [];
  List<String> aiChats = [];

  Future<void> sendChat() async {
    if (_chatController.text.isEmpty) return;

    setState(() {
      userChats.add(_chatController.text);
    });

    var response = await _openai.sendChat(_chatController.text);

    String fullAiResponse = response.choices[0].message.content;

    if (mounted) {
      setState(() {
        aiChats.add(fullAiResponse);
      });
    }

    _chatController.clear();
  }

  double getWidth(BuildContext context) {
    var size = MediaQuery.sizeOf(context).width - 800;
    return size < 260 ? size : 260;
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: getWidth(context),
          height: MediaQuery.sizeOf(context).height - (showConsole ? consoleHeight + 60 : 60),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 240, 240, 240)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: userChats.length + aiChats.length,
                  itemBuilder: (context, index) {
                    List<Widget> chatWidgets = [];

                    if (index % 2 == 0) {
                      int userIndex = index ~/ 2;
                      chatWidgets.add(
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(userChats[userIndex]),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (index % 2 == 1) {
                      int aiIndex = index ~/ 2;
                      chatWidgets.add(
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 249, 249, 249),
                              border: Border.all(color: const Color.fromARGB(255, 214, 214, 214)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(aiChats[aiIndex]),
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: chatWidgets,
                    );
                  },

                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: getWidth(context) - 2,
                    height: 50,
                    child: FleetField(
                      isSubmittable: true,
                      onClickOff: () async {
                        await sendChat();
                      },
                      controller: _chatController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}