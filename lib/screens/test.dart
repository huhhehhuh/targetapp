import 'package:flutter/material.dart';
import 'package:targetapp/main.dart';
import '../assets/target_voca_list.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TestArgs;
    return const Placeholder();
  }
}

class TestArgs {
  final String problemForm;
  final String answerForm;
  final bool isMultipleChoice;
  final int problemCount;

  TestArgs({
    required this.problemForm,
    required this.answerForm,
    required this.isMultipleChoice,
    required this.problemCount,
  });
}
