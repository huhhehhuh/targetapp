import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/testSetting.dart';
import 'screens/setting.dart';

void main() {
  runApp(const TargetApp());
}

class TargetApp extends StatelessWidget {
  const TargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Target App',
        routes: {
          '/': (context) => const Home(),
          '/testsetting': (context) => const TestSetting(),
          '/setting': (context) => const Setting(),
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  String problemForm = '한글단어';
  String answerForm = '영단어';
  bool isMultipleChoice = true;
  int problemCount = 10;
  int grade = 2;
  List<int> targetVoca = [];
  List<List<int>> voca = [];
  List<int> favorites = [];
  List<int> wrong = [];
}
