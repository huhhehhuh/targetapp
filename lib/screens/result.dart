import 'package:flutter/material.dart';
import 'package:targetapp/screens/test.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late double _accuracy;
  late ResultArgs _args;
  late final _appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState = Provider.of<AppState>(context, listen: false);
    _args = ModalRoute.of(context)!.settings.arguments as ResultArgs;
    _accuracy = _args.correctCount / _args.totalCount * 100;
  }

  void _showWrongList(BuildContext context) {
    // showDialog(
    //   context: context, 
    //   builder: (context) => AlertDialog(
    //     title: Text('틀린 문제 목록'),
    //     content: SizedBox(
    //       width: MediaQuery.of(context).size.width * 0.7,
    //       height : MediaQuery.of(context).size.height * 0.8,
    //       child: ListView.separated(
    //         itemCount: _args.wrongs.length,
    //         separatorBuilder: (context, index) => Divider(),
    //         itemBuilder: (context, index) {
    //           final wrong = _args.wrongs[index];
    //           final voca = _appState.voca;
    //           return Row(
    //             children: [
    //               Text('wrong[0]번'),
    //             ],
    //           );
    //         },
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: Text('닫기'),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('시험 결과', style: TextStyle(fontSize: 24)),
                SizedBox(height: 10),
                //시험 결과 내용
                Text(
                  '정답률 ${double.parse(_accuracy.toStringAsFixed(2))}%(${_args.correctCount}/${_args.totalCount})',
                  style: TextStyle(fontSize: 20),
                ),

                if (_args.wrongs.isNotEmpty)
                  Column(
                    children: [
                      //얘는 나중에 수정해서 업데이트
                      // SizedBox(
                      //   width: 300,
                      //   height: 50,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //     ),
                      //     onPressed: () => _showWrongList(context),
                      //     child: Text('틀린문제 보기'),
                      //   ),
                      // ),
                      // SizedBox(height: 10),
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
                            Navigator.pushNamed(
                              context,
                              '/test',
                              arguments: TestArgs(
                                title: '${_args.testNumber + 1}차 복습',
                                problemForm: _args.problemForm,
                                answerForm: _args.answerForm,
                                isMultipleChoice: _args.isMultipleChoice,
                                problemCount:
                                    _args.totalCount - _args.correctCount,
                                testList: Provider.of<AppState>(
                                  context,
                                  listen: false,
                                ).makeTest(
                                  problemCount:
                                      _args.totalCount - _args.correctCount,
                                  isMultipleChoice: _args.isMultipleChoice,
                                  testDomain: _args.wrongs.map((e) => e[0]).toList(),
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
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    child: Text('홈으로', style: TextStyle(fontSize: 16)),
                  ),
                ),
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
