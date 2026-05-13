import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/target_voca_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/target_voca_list.dart';
import '../main.dart';
import 'result.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late final appState;
  late TestArgs _args;
  final TextEditingController _answerController = TextEditingController();
  static const Map<String, int> _transFormat = {'한글단어': 3, '영단어': 2, '영영풀이': 4};
  int trans(String format) {
    return _transFormat[format] ??
        (throw ArgumentError('Invalid field: $format'));
  }

  late int _testNumber;
  late int _problemNumber; //문제번호
  late int _totalCount; //총 문제 수
  int? _selectedOption;
  late int _correctCount;
  late List<List<int>> _wrongs;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppState>(context, listen: false);
    _args = ModalRoute.of(context)!.settings.arguments as TestArgs;
    _totalCount = _args.problemCount;
    _problemNumber = 1;
    _selectedOption = null;
    _correctCount = 0;
    _testNumber = _args.testNumber;
    _wrongs = [];
  }

  void nextProblem() {
    //다음 문제
    if (_problemNumber < _totalCount) {
      setState(() {
        _problemNumber++;
        _selectedOption = null;
      });
    } else {
      //시험 종료

      Navigator.pushNamed(
        context,
        '/result',
        arguments: ResultArgs(
          correctCount: _correctCount,
          totalCount: _totalCount,
          problemForm: _args.problemForm,
          answerForm: _args.answerForm,
          isMultipleChoice: _args.isMultipleChoice,
          wrongs: _wrongs..sort((a, b) => a[0].compareTo(b[0])),
          testNumber: _testNumber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _args.testList.forEach((item) => debugPrint(item.toString()));
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_args.title}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // 문제 부분
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: Text(
                      '$_problemNumber. ${targetVoca[_args.testList[_problemNumber - 1][0]][trans(_args.problemForm)]}',
                      style: TextStyle(fontSize: 19),
                    ),
                  ),
                  SizedBox(height: 20),

                  // 선지 부분
                  //객관식 -> 나중에 elevetedButton으로 바꾸기. 꼭! fuck, 토글은 개별 버튼 디자인이 안돼서 너무 짜침
                  if (_args.isMultipleChoice)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final isSelected = _selectedOption == index;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              minimumSize: const Size(400, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: isSelected
                                  ? Colors.blue
                                  : Colors.grey[200],
                              foregroundColor: isSelected
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedOption = index;
                              });
                            },
                            child: Text(
                              targetVoca[_args.testList[_problemNumber -
                                  1][index + 1]][trans(_args.answerForm)],
                            ),
                          ),
                        );
                      }),
                    )
                  else //주관식
                    Column(
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextField(
                            autofocus: true,
                            controller: _answerController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),

                  // 제출/다음 버튼
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      bool isCorrect;
                      String correctAnswer =
                          targetVoca[_args.testList[_problemNumber -
                              1][0]][trans(_args.answerForm)];
                      if (_args.isMultipleChoice) {
                        if (_selectedOption ==
                            _args.testList[_problemNumber - 1][6]) {
                          setState(() => _correctCount++);
                          isCorrect = true;
                          //정답 유무에 따른 애니메이션 구현해야됨
                        } else {
                          isCorrect = false;
                          _wrongs.add(_args.testList[_problemNumber - 1]);
                          context.read<AppState>().addWrong(
                            _args.testList[_problemNumber - 1][0],
                          );
                        }
                      } else {
                        if (_answerController.text.trim() ==
                            targetVoca[_args.testList[_problemNumber -
                                1][0]][trans(_args.answerForm)]) {
                          setState(() => _correctCount++);
                          isCorrect = true;
                        } else {
                          isCorrect = false;
                          _wrongs.add(_args.testList[_problemNumber - 1]);
                          context.read<AppState>().addWrong(
                            _args.testList[_problemNumber - 1][0],
                          );
                          //사람이 어? 좀 놓칠수도있지. ?tq?
                        }
                        _answerController.clear();
                      }

                      nextProblem();

                      //showDialog써서 화면 가운데에 띄우려했는데 실패. 일단 스낵바로 해놓음.
                      if (isCorrect) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('정답'),
                            backgroundColor: Colors.green,
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('오답. $correctAnswer'),
                            backgroundColor: Colors.red,
                            duration: Duration(milliseconds: 1500),
                          ),
                        );
                      }
                    },
                    child: Text('다음'),
                  ),
                ],
              ),
            ),
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
  final List<List<int>> testList;
  final String title;
  final int testNumber;

  TestArgs({
    required this.title,
    required this.problemForm,
    required this.answerForm,
    required this.isMultipleChoice,
    required this.problemCount,
    required this.testList,
    required this.testNumber,
  });
}
