import 'dart:io';

import 'package:fleet/kanban/views/board.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_field.dart';
import 'package:fleet/kanban/widgets/common/misc/fleet_text.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _passController = TextEditingController();

  void checkPass() {
    final pass = Platform.environment['db_pass'];

    if (_passController.text != pass) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const BoardView())
    );
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
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return const FleetText(
      text: "authenticate", 
      size: 14, 
      weight: FontWeight.w500, 
      colour: Colors.grey
    );
  }

  Widget _field() {
    return SizedBox(
      width: 240, height: 50,
      child: FleetField(
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