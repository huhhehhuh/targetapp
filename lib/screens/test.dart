import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:targetapp/main.dart';
import '../assets/target_voca_list.dart';
import 'package:provider/provider.dart';

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

@override
void initState() {// 화면이 처음 로드될 때 Provider 초기화
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final args = ModalRoute.of(context)!.settings.arguments as TestArgs;
    context.read<TestProvider>().initTest(args.problemCount);
  });
}

@override
Widget build(BuildContext context) {
  final args = ModalRoute.of(context)!.settings.arguments as TestArgs;
  final testProv = context.watch<TestProvider>();
  
  if (testProv.testList.isEmpty) return CircularProgressIndicator();

    // 시험 종료 시 결과 페이지로 이동하거나 메시지 표시
    if (testProv.isFinished) {
      //결과 페이지 이동 로직
    }

    final currentVocab = targetVoca[testProv.testList[testProv.problemNumber - 1]];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 문제 부분
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 200),
                child: Text(
                  '${testProv.problemNumber}. ${currentVocab[trans(args.problemForm)]}',
                ),
              ),
              
              // 선지 부분
              if (!args.isMultipleChoice) //객관식
                Column(
                  children: [
                    for (int i = 0; i < 4; i++)
                      ElevatedButton(
                        onPressed: () { /* 정답 체크 로직 */ },
                        child: Text(currentVocab[trans(args.answerForm)]),
                      ),
                  ],
                )
              else //주관식
                Column(children: [TextField()]),
          
              // 제출/다음 버튼
              ElevatedButton(
                onPressed: () {
                  testProv.nextProblem(args.problemCount);
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

  TestArgs({
    required this.problemForm,
    required this.answerForm,
    required this.isMultipleChoice,
    required this.problemCount,
  });
}

class TestProvider with ChangeNotifier {
  int _problemNumber = 1;
  late List<int> _testList;
  bool _isFinished = false;

  int get problemNumber => _problemNumber;
  List<int> get testList => _testList;
  bool get isFinished => _isFinished;

  // 초기화: AppState에서 시험 리스트를 받아옴
  void initTest(int count) {
    _testList = AppState().makeTest(problemCount: count);
    _problemNumber = 1;
    _isFinished = false;
  }

  void nextProblem(int totalCount) {
    if (_problemNumber < totalCount) {
      _problemNumber++;
      notifyListeners(); // 화면 업데이트 요청
    } else {
      _isFinished = true;
      notifyListeners();
    }
  }
}
