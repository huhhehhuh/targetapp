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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _args = ModalRoute.of(context)!.settings.arguments as ResultArgs;
    _accuracy = _args.correctCount / _args.totalCount * 100;
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Result', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                //시험 결과 내용
                Text(
                  '정답률 ${double.parse(_accuracy.toStringAsFixed(2))}%',
                  style: TextStyle(fontSize: 20),
                ),

                if (_args.wrongs.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/test',
                        arguments: TestArgs(
                          title: '${_args.testNumber+1}차 복습',
                          problemForm: _args.problemForm,
                          answerForm: _args.answerForm,
                          isMultipleChoice: _args.isMultipleChoice,
                          problemCount: _args.totalCount - _args.correctCount,
                          testList: _args.wrongs,
                          testNumber: _args.testNumber + 1,
                        ),
                      );
                    }, 
                    child: Text('${_args.testNumber+1}차 복습하러가기'),
                  ),
            
                //홈으로
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/'),
                  child: Text('홈으로', style: TextStyle(fontSize: 16)),
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
    required this.wrongs
  });
}
