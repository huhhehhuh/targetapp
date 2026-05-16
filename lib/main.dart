import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'assets/test_domain.dart';
import 'screens/home.dart';
import 'screens/result.dart';
import 'screens/setting.dart';
import 'screens/target_view.dart';
import 'screens/test.dart';
import 'screens/test_setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.loadData();

  runApp(
    ChangeNotifierProvider.value(value: appState, child: const TargetApp()),
  );
}
//앱 배포할때 꼭 로컬 DB에 오답노트, 즐겨찾기 저장하게 수정 - 내가해뒀어.

//주관식에서는 답안 양식에 영단어 이외로 선택하면 경고메시지
class TargetApp extends StatelessWidget {
  const TargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Target App',
      routes: {
        '/': (context) => const Home(),
        '/testsetting': (context) => const TestSetting(),
        '/setting': (context) => const Setting(),
        '/test': (context) => const Test(),
        '/targetview': (context) => const TargetView(),
        '/result': (context) => const Result(),
      },
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
  Map<int, int> wrong = {}; //틀린 문제 번호와 틀린 횟수 저장

  //즐겨찾기 초기화 함수
  Future<void> resetFavorites() async {
    favorites.clear();
    await saveFavorites();
    notifyListeners();
  }

  Future<void> resetWrong() async {
    wrong.clear();
    await saveWrong();
    notifyListeners();
  }

  //틀린 문제 추가 함수
  Future<void> addWrong(int wordNumber) async {
    wrong[wordNumber] = (wrong[wordNumber] ?? 0) + 1;
    await saveWrong();
    notifyListeners();
  }

  //설정 저장 함수
  Future<void> saveSettings({
    required int? grade,
    required String? problemForm,
    required String? answerForm,
    required bool isMultipleChoice,
    required int problemCount,
  }) async {
    this.grade = grade ?? this.grade;

    if (this.grade < 0 || this.grade >= testDomain.length) {
      this.grade = 2;
    }

    voca = testDomain[this.grade];

    this.problemForm = problemForm ?? this.problemForm;
    this.answerForm = answerForm ?? this.answerForm;
    this.isMultipleChoice = isMultipleChoice;
    this.problemCount = problemCount;

    await saveAppSettings();
    notifyListeners();
  }

  Future<void> loadData() async {
    //즐겨찾기 오답노트 불러오기
    final prefs = await SharedPreferences.getInstance();

    final favoriteData = prefs.getStringList('favorites');
    if (favoriteData != null) {
      favorites = favoriteData.map(int.tryParse).whereType<int>().toList();
    }

    final wrongData = prefs.getString('wrong');
    if (wrongData != null) {
      try {
        final decoded = jsonDecode(wrongData) as Map<String, dynamic>;

        wrong = decoded.map(
          (key, value) => MapEntry(int.parse(key), (value as num).toInt()),
        );
      } catch (_) {
        wrong = {};
        await saveWrong();
      }
    }

    //설정 불러오기
    problemForm = prefs.getString('problemForm') ?? problemForm;
    answerForm = prefs.getString('answerForm') ?? answerForm;
    isMultipleChoice = prefs.getBool('isMultipleChoice') ?? isMultipleChoice;
    problemCount = prefs.getInt('problemCount') ?? problemCount;
    grade = prefs.getInt('grade') ?? grade;

    if (grade < 0 || grade >= testDomain.length) {
      grade = 2;
      await saveAppSettings();
    }

    //저장된 학년에 맞게 시험 범위 다시 설정
    voca = testDomain[grade];

    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'favorites',
      favorites.map((e) => e.toString()).toList(),
    );
  }

  Future<void> saveWrong() async {
    final prefs = await SharedPreferences.getInstance();

    final wrongToSave = wrong.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    await prefs.setString('wrong', jsonEncode(wrongToSave));
  }

  Future<void> saveAppSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('problemForm', problemForm);
    await prefs.setString('answerForm', answerForm);
    await prefs.setBool('isMultipleChoice', isMultipleChoice);
    await prefs.setInt('problemCount', problemCount);
    await prefs.setInt('grade', grade);
  }

  //문제 만들기
  List<List<int>> makeTest({
    required int problemCount,
    required bool isMultipleChoice,
    required List<int> testDomain,
  }) {
    final shuffled = List<int>.from(testDomain)..shuffle();

    final int realProblemCount = problemCount > shuffled.length
        ? shuffled.length
        : problemCount;

    if (!isMultipleChoice) {
      //[문제번호]
      return shuffled.take(realProblemCount).map((e) => [e]).toList();
    } else {
      //[문제번호, 선지1~5, 정답번호]
      final List<List<int>> problems = [];

      for (int i = 0; i < realProblemCount; i++) {
        final int problemNumber = shuffled[i];

        final List<int> options = [problemNumber];

        while (options.length < 5) {
          final int option = voca[Random().nextInt(voca.length)];

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

  Future<void> toggleFavorite(int wordNumber) async {
    if (favorites.contains(wordNumber)) {
      favorites.remove(wordNumber);
    } else {
      favorites.add(wordNumber);
    }

    await saveFavorites();
    notifyListeners();
  }
}
