import 'package:flutter/material.dart';
import 'package:test_task_tbr_group/constants.dart';
import 'package:test_task_tbr_group/widgets/body_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgroundColor,
      body: Body(),
    );
  }
}
