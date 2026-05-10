import 'package:flutter/material.dart';
import 'package:targetapp/main.dart';
import 'package:provider/provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //학년 설정
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('학년:', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 10),
                  DropdownButton<int>(
                    value: _selectedGrade,
                    items: [1, 2, 3]
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text('$e학년'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedGrade = value);
                    },
                  ),
                ],
              ),

              SizedBox(height: 30),
              Text('기본 세팅 설정', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              //문제 유형
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                          initialValue: _dropDownProblem,
                          // items: ['한글단어', '영단어', '영영풀이', '문장']
                          //     .map(
                          //       (e) => DropdownMenuItem<String>(
                          //         value: e,
                          //         child: Text(e),
                          //       ),
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
                            setState(() => _dropDownProblem = value);
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
                          initialValue: _dropDownAnswer,
                          items: ['한글단어', '영단어']
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _dropDownAnswer = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),
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

              SizedBox(height: 30),
              //문제수 설정
              Text('문제 수', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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

              SizedBox(height: 20),
              //설정 저장 버튼
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_dropDownProblem == _dropDownAnswer) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('오류', style: TextStyle(color: Colors.red)),
                        content: Text('문제와 답안의 유형이 같을 수 없어요.'),
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
                  if (!_isMultipleChoice && _dropDownAnswer != '영단어') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('오류', style: TextStyle(color: Colors.red)),
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
                  final appState = Provider.of<AppState>(
                    context,
                    listen: false,
                  );
                  appState.saveSettings(
                    grade: _selectedGrade,
                    problemForm: _dropDownProblem,
                    answerForm: _dropDownAnswer,
                    isMultipleChoice: _isMultipleChoice,
                    problemCount: _selectedCount,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('설정이 저장되었어요.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pushNamed(context, '/');
                },
                child: Text('저장', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 30),
              //즐겨찾기 초기화
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('초기화'),
                      content: Text('즐겨찾기를 초기화하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('취소'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            final appState = Provider.of<AppState>(
                              context,
                              listen: false,
                            );
                            appState.resetFavorites();
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('즐겨찾기 초기화', style: TextStyle(fontSize: 16)),
              ),

              SizedBox(height: 10),
              //오답 초기화
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('초기화'),
                      content: Text('오답을 초기화하시겠습니까?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('취소'),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            final appState = Provider.of<AppState>(
                              context,
                              listen: false,
                            );
                            appState.resetWrong();
                          },
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  fixedSize: Size(300, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('오답 초기화', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
