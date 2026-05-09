import 'package:flutter/material.dart';
import 'package:targetapp/main.dart';
import 'test.dart';
import 'package:provider/provider.dart';

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
  final List<int> _counts = [10, 30, 50, 80, 100, 200, 300, 400];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _dropDownFirst = appState.problemForm;
    _dropDownLatter = appState.answerForm;
    _isMultipleChoice = appState.isMultipleChoice;
    _selectedCount = appState.problemCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('시험지 설정')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //시험 유형 설정
              Text('시험 유형 설정', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('문제:'),
                  SizedBox(width: 10),

                  //첫 번째 드롭다운
                  Container(
                    width: 110,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _dropDownFirst,
                      // items: ['한글단어', '영단어', '영영풀이', '문장']
                      //     .map(
                      //       (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                      //     )
                      //     .toList(),
                      items:
                          [
                                '한글단어',
                                '영단어',
                                '영영풀이',
                              ] //지금은 beta1버전이라서 문장은 없이 하고 나중에 바꿈.
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() => _dropDownFirst = value);
                      },
                    ),
                  ),
                  SizedBox(width: 15),
                  Icon(Icons.arrow_forward_ios, size: 16),
                  SizedBox(width: 15),
                  Text('답안:'),
                  SizedBox(width: 10),

                  //두번째 드롭다운
                  Container(
                    width: 110,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      initialValue: _dropDownLatter,
                      items: ['한글단어', '영단어']
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _dropDownLatter = value);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              //객관식/주관식
              ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                isSelected: [_isMultipleChoice, !_isMultipleChoice],
                onPressed: (index) {
                  setState(() => _isMultipleChoice = (index == 0));
                },
                children: ['객관식', '주관식']
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(e),
                      ),
                    )
                    .toList(),
              ),

              SizedBox(height: 50),

              //문제수 설정
              Text('문제 수 설정', style: TextStyle(fontSize: 24)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      //윗줄 4개(10개, 30개, 50개, 80개)
                      ToggleButtons(
                        constraints: BoxConstraints(
                          maxWidth: 80,
                          minWidth: 80,
                          minHeight: 40,
                        ),
                        isSelected: _counts
                            .sublist(0, 4)
                            .map((e) => (e == _selectedCount))
                            .toList(),
                        onPressed: (index) {
                          setState(() => _selectedCount = _counts[index]);
                        },
                        borderRadius: BorderRadius.circular(8),
                        children: _counts
                            .sublist(0, 4)
                            .map((e) => Text('$e개'))
                            .toList(),
                      ),

                      //아랫줄 4개(100개, 200개, 300개, 400개)
                      ToggleButtons(
                        constraints: BoxConstraints(
                          maxWidth: 80,
                          minWidth: 80,
                          minHeight: 40,
                        ),
                        isSelected: _counts
                            .sublist(4, 8)
                            .map((e) => (e == _selectedCount))
                            .toList(),
                        onPressed: (index) {
                          setState(() => _selectedCount = _counts[index + 4]);
                        },
                        borderRadius: BorderRadius.circular(8),
                        children: _counts
                            .sublist(4, 8)
                            .map((e) => Text('$e개'))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 40),
              //시작 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 18),
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    // side: BorderSide(width: 2),
                  ),
                ),
                onPressed: () {
                  //예외 처리
                  if (_dropDownFirst == _dropDownLatter) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('오류', style: TextStyle(color: Colors.red),),
                        content: Text('문제 유형과 선지가 같을 수 없어요.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  if (!_isMultipleChoice && _dropDownLatter != '영단어') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('오류', style: TextStyle(color: Colors.red),),
                        content: Text('주관식은 답안 유형이 영단어여야 해요.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  //주관식의 경우 answerform이 영단어 아니면 불가능하게

                  Navigator.pushNamed(
                    context,
                    '/test',
                    arguments: TestArgs(
                      title: '시험',
                      problemForm: _dropDownFirst!,
                      answerForm: _dropDownLatter!,
                      isMultipleChoice: _isMultipleChoice,
                      problemCount: _selectedCount,
                      testNumber: 0,
                      testList: Provider.of<AppState>(
                        context,
                        listen: false,
                      ).makeTest(
                        problemCount: _selectedCount, 
                        isMultipleChoice: _isMultipleChoice,
                        testDomain: Provider.of<AppState>(context, listen: false).voca,
                      ),
                    ),
                  );
                },
                child: Text('시작'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
