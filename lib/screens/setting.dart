import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:targetapp/main.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late int? _selectedGrade;
  late String? _dropDownProblem;
  late String? _dropDownAnswer;
  late bool _isMultipleChoice;
  late int _selectedCount;
  late String _themeModeName;

  final List<int> _counts = [10, 30, 50, 80, 100, 200, 300, 400];
  @override
  void initState() {
    super.initState();

    final appState = Provider.of<AppState>(context, listen: false);

    _selectedGrade = appState.grade;
    _dropDownProblem = appState.problemForm;
    _dropDownAnswer = appState.answerForm;
    _isMultipleChoice = appState.isMultipleChoice;
    _selectedCount = appState.problemCount;
    _themeModeName = appState.themeModeName;
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          '오류',
          style: TextStyle(color: Colors.red),