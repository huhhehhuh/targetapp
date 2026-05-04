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

  //즐겨찾기 초기화 함수
  void resetFavorites() {
    favorites = [];
  }

  //오답 초기화 함수
  void resetWrong() {
    wrong = [];
  }

  void saveSettings({
    required int? grade,
    required String? problemForm,
    required String? answerForm,
    required bool isMultipleChoice,
    required int problemCount,
  }) {
    this.grade = grade ?? this.grade;
    this.problemForm = problemForm ?? this.problemForm;
    this.answerForm = answerForm ?? this.answerForm;
    this.isMultipleChoice = isMultipleChoice;
    this.problemCount = problemCount;
    notifyListeners();
  }
}
