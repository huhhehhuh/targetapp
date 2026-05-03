import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/testSetting.dart';

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
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  String problemForm = '한글단어';
  String answerForm = '영단어';
  bool isMultipleChoice = true;
}
