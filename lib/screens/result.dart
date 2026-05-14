import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/target_voca_list.dart'; //그시깽이 단어 보여주려고 데꼬옴
import '../main.dart';
import 'test.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late double _accuracy;
  late ResultArgs _args;
  late final _appState;
  late List<bool> _wrongSelections;
  bool _wrongSaved = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    _appState = Provider.of<AppState>(context, listen: false);
    _args = ModalRoute.of(context)!.settings.arguments as ResultArgs;
    _accuracy = _args.correctCount / _args.totalCount * 100;

    _wrongSelections = List<bool>.filled(_args.wrongs.length, true);
  }

  void _saveSelectedWrongs() {
    if (_wrongSaved) return;

    final appState = context.read<AppState>();

    for (int i = 0; i < _args.wrongs.length; i++) {
      if (_wrongSelections[i]) {
        appState.addWrong(_args.wrongs[i][0]);
      }
    }

    _wrongSaved = true;
  }

  void _showWrongList(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('오답 보기'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.separated(
                  itemCount: _args.wrongs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final wrong = _args.wrongs[index];
                    final int wordNumber = wrong[0];

                    final wordData = targetVoca[wordNumber];
                    final String word = wordData[2].toString();
                    final String koreanMeaning = wordData[3].toString();

                    return CheckboxListTile(
                      value: _wrongSelections[index],
                      onChanged: (value) {
                        setState(() {
                          _wrongSelections[index] = value ?? true;
                        });

                        setDialogState(() {});
                      },
                      title: Text(
                        '$wordNumber. $word',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(koreanMeaning),
                          const SizedBox(height: 4),
                          Text(_wrongSelections[index] ?
                          '오답노트에 추가됨' : '오답노트에 추가 안함',
                          style: TextStyle(
                            fontSize: 12,
                            color: 
                            _wrongSelections[index] ? Colors.red : Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          )
                        ],
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('닫기'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,

          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text('시험 결과', style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                //시험 결과 내용
                Text(
                  '정답률 ${double.parse(_accuracy.toStringAsFixed(2))}%(${_args.correctCount}/${_args.totalCount})',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),

                if (_args.wrongs.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _showWrongList(context),
                          child: const Text('오답 보기'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            _saveSelectedWrongs();

                            Navigator.pushReplacementNamed(
                              context,
                              '/test',
                              arguments: TestArgs(
                                title: '${_args.testNumber + 1}차 복습',
                                problemForm: _args.problemForm,
                                answerForm: _args.answerForm,
                                isMultipleChoice: _args.isMultipleChoice,
                                problemCount:
                                    _args.totalCount - _args.correctCount,
                                testList:
                                    Provider.of<AppState>(
                                      context,
                                      listen: false,
                                    ).makeTest(
                                      problemCount:
                                          _args.totalCount - _args.correctCount,
                                      isMultipleChoice: _args.isMultipleChoice,
                                      testDomain: _args.wrongs
                                          .map((e) => e[0])
                                          .toList(),
                                    ),
                                testNumber: _args.testNumber + 1,
                              ),
                            );
                          },
                          child: Text('${_args.testNumber + 1}차 복습'),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),

                //홈으로
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      _saveSelectedWrongs();

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    child: Text('홈으로', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultArgs {
  final int correctCount;
  final int totalCount;

  final String problemForm;
  final String answerForm;
  final bool isMultipleChoice;
  final List<List<int>> wrongs;
  final int testNumber;

  ResultArgs({
    required this.correctCount,
    required this.totalCount,
    required this.problemForm,
    required this.answerForm,
    required this.isMultipleChoice,
    required this.testNumber,
    required this.wrongs,
  });
}
