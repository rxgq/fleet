import 'dart:io';
import 'package:fleet/kanban/views/board.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_field.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _passController = TextEditingController();
  final _audioPlayer = AudioPlayer();

  int incorrectAttempts = 0;
  String lastAnswered = "";

  void checkPass() async {
    final pass = Platform.environment['db_pass'];

    if (_passController.text != pass) {
      lastAnswered = _passController.text;

      await _playAudio('audio/siren.mp3');

      setState(() {
        incorrectAttempts++;
      });

      return;
    }

    await _playAudio('audio/android_ringtone.mp3');

    setState(() {
      _passController.clear();
      incorrectAttempts = 0;
    });

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BoardView())
    );
  }

  Future<void> _playAudio(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _header(),
            _field(),
            _incorrectMessage()
          ],
        ),
      ),
    );
  }

  Widget _incorrectMessage() {
    return FleetText(
      text: getIncorrectMessage(), 
      size: 14, 
      weight: FontWeight.w500, 
      colour: Colors.grey
    );
  }

  String getIncorrectMessage() {
    return switch (incorrectAttempts) {
      0   => "",
      1   => "incorrect",
      2   => "incorrect again",
      3   => "incorrect x3",
      4   => "incorrect x4",
      5   => "incorrect x5",
      6   => "please go away",
      7   => "you won't get in",
      8   => "okay, you can have a clue",
      9   => "it's a 6 digit number",
      10  => "that's 1,000,000 combinations",
      11  => "you could try them all..",
      12  => "or just go away",
      13  => "okay, it's 192005",
      14  => lastAnswered == "192005" ? "idiot, as if lmao" : "okay obviously it wasn't",
      15  => "why would i leave my computer unattended",
      16  => "i'm not sure",
      17  => "i must be coming back soon",
      18  => "this device will self destruct in..",
      19  => "3..",
      20  => "2..",
      21  => "1..",
      22  => "...",
      23  => "oh hiya mornin' guys, yeah do do do do",
      24  => "harry'll love that one lol",
      25  => "incorrect x25", 
      50  => "incorrect x50" ,
      100 => "incorrect x100, jesus go away" ,
      _   => "..."
    };
  }

  Widget _header() {
    return const FleetText(
      text: "enter pin", 
      size: 14, 
      weight: FontWeight.w500, 
      colour: Colors.grey
    );
  }

  Widget _field() {
    return SizedBox(
      width: 240, height: 50,
      child: FleetField(
        autoFocus: true,
        obscure: true,
        onClickOff: () {
          checkPass();
        }, 
        controller: _passController,
        isSubmittable: true,
      ),
    );
  }
}
