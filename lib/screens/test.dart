import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:targetapp/main.dart';
import '../assets/target_voca_list.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Test extends StatefulWidget {
  @Preview()
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  static const Map<String, int> _transFormat = {'한글단어': 3, '영단어': 2, '영영풀이': 4};
  int trans(String format) {
    return _transFormat[format] ??
        (throw ArgumentError('Invalid field: $format'));
  }

  late int _problemNumber; //문제번호(problemCount는 총 문제수)
  late int _totalCount;
  late List<int> _wrongs;
  late List<int> _options;
  int? _selectedOption;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _problemNumber = 1;
    _totalCount = appState.problemCount;
    _wrongs = [];
    _options = [];
    _selectedOption = null;
  }

  void makeOptions({required int vocaNumber}) {
    _selectedOption = null;
    var random = Random();
    Set<int> optionsSet = {vocaNumber};
    while (optionsSet.length < 5) {
      optionsSet.add(random.nextInt(vocaLength-1)+1);
    }
    _options = optionsSet.toList();
    _options.shuffle();
  }

  void nextProblem() {
    //다음 문제
    if (_problemNumber < _totalCount) {
      setState(() {
        _problemNumber++;
      });
    } else {
      //시험 종료
      Navigator.pushNamed(context, '/result');
    }
  }

  void grading() {
    //채점
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TestArgs;
    final currentVocab = targetVoca[args.testList[_problemNumber - 1]];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${args.title}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // 문제 부분
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Text(
                  '$_problemNumber. ${currentVocab[trans(args.problemForm)]}',
                ),
              ),

              // 선지 부분 -> 상세 구현은 나중에. 일단은 문제 부분만 구현해놓고 선지는 다음 단계에서.
              if (!args.isMultipleChoice) //객관식
                Column(
                  children: [
                    ToggleButtons(
                      constraints: BoxConstraints(
                        maxWidth: 100,
                        minWidth: 100,
                        maxHeight: 40,
                      ),
                      isSelected: List.generate(
                        5, (i) => i == _selectedOption,
                      ),
                      onPressed: (int index) {
                        setState(() {
                          _selectedOption = index;
                        });
                      },
                      children: _options
                          .map(
                            (i) => Text(
                              targetVoca[args.testList[_options[i]]][trans(
                                args.answerForm,
                              )],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              else //주관식
                Column(children: [TextField()]),

              // 제출/다음 버튼
              ElevatedButton(
                onPressed: () {
                  grading();
                  nextProblem();
                  if (!args.isMultipleChoice) {
                    makeOptions(vocaNumber: args.testList[_problemNumber - 1]);
                  } else {
                    //주관식일때 문제 및 정답 갱신
                  }
                },
                child: Text('다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestArgs {
  final String problemForm;
  final String answerForm;
  final bool isMultipleChoice;
  final int problemCount;
  final List<int> testList;
  final String title;

  TestArgs({
    required this.title,
    required this.problemForm,
    required this.answerForm,
    required this.isMultipleChoice,
    required this.problemCount,
    required this.testList,
  });
}
