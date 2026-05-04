import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/test_setting.dart';
import 'screens/setting.dart';
import 'assets/target_voca_list.dart';
import 'assets/test_domain.dart';
import 'screens/test.dart';

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
          '/test': (context) => const Test(),
        },
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  String problemForm = '한글단어';
  String answerForm = '영단어';
  bool isMultipleChoice = false;
  int problemCount = 10;
  int grade = 2;
  List<int> voca = testDomain[1]; //얘는 int로 번호만 저장되어 있음
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

  //설정 저장 함수
  void saveSettings({
    required int? grade,
    required String? problemForm,
    required String? answerForm,
    required bool isMultipleChoice,
    required int problemCount,
  }) {
    if (this.grade != grade) {
      voca = testDomain[this.grade];
    }
    this.grade = grade ?? this.grade;
    this.problemForm = problemForm ?? this.problemForm;
    this.answerForm = answerForm ?? this.answerForm;
    this.isMultipleChoice = isMultipleChoice;
    this.problemCount = problemCount;
    notifyListeners();
  }

  List<int> makeTest({required int? problemCount}) {
    final shuffled = List<int>.from(voca)..shuffle();
    return shuffled.take(problemCount ?? this.problemCount).toList();
  }
}
