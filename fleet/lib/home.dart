import 'package:fleet/db.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _db = DatabaseService();

  @override
  void initState() {
    _db.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}