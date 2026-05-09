import 'package:flutter/material.dart';
import '../assets/target_voca_list.dart';
import 'package:targetapp/screens/result.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
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

    return Scaffold(
      appBar: AppBar(title: Text(
                  '${_args.title}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                    children: [
                      ToggleButtons(
                        direction: Axis.vertical,
                        borderRadius: BorderRadius.circular(8),
                        isSelected: List<bool>.generate(
                          5,
                          (i) => i == _selectedOption,
                        ),
                        onPressed: (int index) {
                          setState(() {
                            _selectedOption = index;
                          });
                        },
                        children: _args.testList[_problemNumber - 1]
                            .sublist(1, 6)
                            .map(
                              (i) => SizedBox(
                                height: 50,
                                width: 400,
                                child: Center(
                                  child: Text(
                                    targetVoca[i][trans(_args.answerForm)],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  )
                else //주관식
                  Column(
                    children: [
                      SizedBox(
                        width : 400,
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
                    if (_args.isMultipleChoice) {
                      if (_selectedOption == _args.testList[_problemNumber-1][6]) {
                        setState(()=> _correctCount++);
                        //정답 유무에 따른 애니메이션 구현해야됨
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('정답'), duration: Duration(milliseconds: 500)),
                        // );
                      } else {
                        _wrongs.add(_args.testList[_problemNumber - 1]);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('오답 / 정답 : ${targetVoca[_args.testList[_problemNumber - 1][0]][trans(_args.answerForm)]}'),
                        //     duration: Duration(milliseconds: 500),
                        //   ),
                        // );
                      }
                    } else {
                      if (_answerController.text.trim() ==
                          targetVoca[_args.testList[_problemNumber - 1][0]][trans(_args.answerForm)]) {
                        setState(() => _correctCount++);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('정답'), duration: Duration(milliseconds: 500)),
                        // );
                      } else {
                        _wrongs.add(_args.testList[_problemNumber - 1]);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('오답 / 정답 : ${targetVoca[_args.testList[_problemNumber - 1][0]][trans(_args.answerForm)]}'),
                        //     duration: Duration(milliseconds: 500),
                        //   ),
                        // );
                      }
                      _answerController.clear();
                    }
                    nextProblem();
                  },
                  child: Text('다음'),
                ),
              ],
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
