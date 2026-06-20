import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:targetapp/main.dart';

import 'test.dart';

class TestSetting extends StatefulWidget {
  const TestSetting({super.key});

  @override
  State<TestSetting> createState() => _TestSettingState();
}

class _TestSettingState extends State<TestSetting> {
  late String? _dropDownFirst;
  late String? _dropDownLatter;
  late bool _isMultipleChoice;
  late int _selectedCount;

  int _rangeStart = 1;
  int _rangeEnd = 400;

  final List<int> _counts = [10, 30, 50, 80, 100, 200, 300, 400];
  final List<int> _wordNumbers = List.generate(400, (index) => index + 1);

  @override
  void initState() {
    super.initState();

    final appState = Provider.of<AppState>(context, listen: false);

    _dropDownFirst = appState.problemForm;
    _dropDownLatter = appState.answerForm;
    _isMultipleChoice = appState.isMultipleChoice;
    _selectedCount = appState.problemCount;
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '오류',
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  List<int> _makeRangedVoca(List<int> appStateVoca) {
    return appStateVoca.where((wordNumber) {
      return wordNumber >= _rangeStart && wordNumber <= _rangeEnd;
    }).toList();
  }

  @override