import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'screens/test_setting.dart';
import 'screens/setting.dart';
import 'assets/test_domain.dart';
import 'screens/test.dart';
import 'screens/target_view.dart';
import 'screens/result.dart';
import 'dart:math';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: TargetApp()));
}

//주관식에서는 답안 양식에 영단어 이외로 선택하면 경고메시지
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
          '/targetview': (context) => const TargetView(),
          '/result': (context) => const Result(),
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
  List<int> voca =
      testDomain[2]; //얘는 int로 번호만 저장되어 있음. 근데 내가 testDomain에서 0번 인덱스를 비워놔서 1-based.
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

  //문제 만들기
  List<List<int>> makeTest({
    required int problemCount,
    required bool isMultipleChoice,
    required List<int> testDomain,
  }) {
    if (!isMultipleChoice) {
      //[문제번호]
      final shuffled = List<int>.from(testDomain)..shuffle();
      return shuffled.take(problemCount).map((e)=>[e]).toList();
    } else {
      //[문제번호, 선지1~5, 정답번호]
      final shuffled = List<int>.from(testDomain)..shuffle();
      final List<List<int>> problems = [];
      for (int i = 0; i < problemCount; i++) {
        int problemNumber = shuffled[i];
        List<int> options = [problemNumber];
        while (options.length < 5) {
          int option = voca[Random().nextInt(voca.length)];
          if (!options.contains(option)) {
            options.add(option);
          }
        }
        options.shuffle();
        problems.add([
          problemNumber,
          ...options,
          options.indexOf(problemNumber),
        ]);
      }
      return problems;
    }
  }
  void toggleFavorite(int wordNumber) { //즐겨찾기 기능
  if (favorites.contains(wordNumber)) {
    favorites.remove(wordNumber);
  } else {
    favorites.add(wordNumber);
  }
  notifyListeners();
}
}
