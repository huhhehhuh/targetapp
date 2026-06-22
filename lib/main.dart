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
    ChangeNotifierProvider.value(
      value: appState,
      child: const TargetApp(),
    ),
  );
}

class TargetApp extends StatelessWidget {
  const TargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Target App',
          themeMode: appState.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          routes: {
            '/': (context) => const Home(),
            '/testsetting': (context) => const TestSetting(),
            '/setting': (context) => const Setting(),
            '/test': (context) => const Test(),
            '/targetview': (context) => const TargetView(),
            '/result': (context) => const Result(),
          },
        );
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
  String themeModeName = 'system';

  List<int> voca = List<int>.from(testDomain[2]);

  List<int> favorites = [];
  Map<int, int> wrong = {};

  ThemeMode get themeMode {
    switch (themeModeName) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

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

  Future<void> addWrong(int wordNumber) async {
    wrong[wordNumber] = (wrong[wordNumber] ?? 0) + 1;
    await saveWrong();
    notifyListeners();
  }

  Future<void> saveSettings({
    required int? grade,
    required String? problemForm,
    required String? answerForm,
    required bool isMultipleChoice,
    required int problemCount,
    String? themeModeName,
  }) async {
    this.grade = grade ?? this.grade;

    if (this.grade < 1 || this.grade > 3 || this.grade >= testDomain.length) {
      this.grade = 2;
    }

    voca = List<int>.from(testDomain[this.grade]);

    this.problemForm = problemForm ?? this.problemForm;
    this.answerForm = answerForm ?? this.answerForm;
    this.isMultipleChoice = isMultipleChoice;
    this.problemCount = problemCount;

    if (themeModeName != null) {
      this.themeModeName = themeModeName;
    }

    if (!['system', 'light', 'dark'].contains(this.themeModeName)) {
      this.themeModeName = 'system';
    }

    await saveAppSettings();
    notifyListeners();
  }

  Future<void> loadData() async {
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
          (key, value) => MapEntry(
            int.parse(key),
            (value as num).toInt(),
          ),
        );
      } catch (_) {
        wrong = {};
        await saveWrong();
      }
    }

    problemForm = prefs.getString('problemForm') ?? problemForm;
    answerForm = prefs.getString('answerForm') ?? answerForm;
    isMultipleChoice = prefs.getBool('isMultipleChoice') ?? isMultipleChoice;
    problemCount = prefs.getInt('problemCount') ?? problemCount;
    grade = prefs.getInt('grade') ?? grade;
    themeModeName = prefs.getString('themeModeName') ?? themeModeName;

    if (grade < 1 || grade > 3 || grade >= testDomain.length) {
      grade = 2;
      await saveAppSettings();
    }

    if (!['system', 'light', 'dark'].contains(themeModeName)) {
      themeModeName = 'system';
      await saveAppSettings();
    }

    voca = List<int>.from(testDomain[grade]);

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
    await prefs.setString('themeModeName', themeModeName);
  }

  List<List<int>> makeTest({
    required int problemCount,
    required bool isMultipleChoice,
    required List<int> testDomain,
  }) {
    final shuffled = List<int>.from(testDomain)..shuffle();
    final realProblemCount =
        problemCount > shuffled.length ? shuffled.length : problemCount;

    if (!isMultipleChoice) {
      return shuffled.take(realProblemCount).map((e) => [e]).toList();
    }

    final random = Random();
    final List<List<int>> problems = [];

    for (int i = 0; i < realProblemCount; i++) {
      final int problemNumber = shuffled[i];
      final List<int> options = [problemNumber];

      while (options.length < 5) {
        final int option = voca[random.nextInt(voca.length)];

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
