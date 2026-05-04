import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:targetapp/main.dart';

class Setting extends StatefulWidget {
  @Preview()
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int? _selectedGrade = AppState().grade;
  String? _dropDownProblem = AppState().problemForm;
  String? _dropDownAnswer = AppState().answerForm;
  bool _isMultipleChoice = AppState().isMultipleChoice;
  int _selectedCount = AppState().problemCount;
  final List<int> _counts = [10, 30, 50, 80, 100, 200, 300, 400];

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    (e) => DropdownMenuItem<int>(value: e, child: Text('$e학년')),
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
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _dropDownProblem,
                    items: ['한글단어', '영단어', '영영풀이', '문장']
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
                SizedBox(width: 30),
                Icon(Icons.arrow_forward_ios, size: 16),
                SizedBox(width: 30),
                Text('선지:'),
                SizedBox(width: 10),

                //두번째 드롭다운
                Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _dropDownAnswer,
                    items: ['한글단어', '영단어', '영영풀이']
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
              children: [
                //윗줄 4개(10개, 30개, 50개, 80개)
                SizedBox(
                  width: 380,
                  child: ToggleButtons(
                    constraints: BoxConstraints(maxWidth: 90, minHeight: 40),
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
                ),

                //아랫줄 4개(100개, 200개, 300개, 400개)
                SizedBox(
                  width: 380,
                  child: ToggleButtons(
                    constraints: BoxConstraints(maxWidth: 90, minHeight: 40),
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
              side: BorderSide(width: 500),
            ),
          ),
          onPressed: () {
            if (_dropDownProblem == _dropDownAnswer) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('오류'),
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  content: Text('문제와 선지의 유형이 같을 수 없어요.'),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
              return;
            }
            AppState().saveSettings(
              grade: _selectedGrade,
              problemForm: _dropDownProblem,
              answerForm: _dropDownAnswer,
              isMultipleChoice: _isMultipleChoice,
              problemCount: _selectedCount,
            );
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('저장 완료'),
                content: Text('설정이 저장되었어요.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('확인'),
                  ),
                ],
              ),
            );
            AppState().saveSettings(
              grade: _selectedGrade,
              problemForm: _dropDownProblem,
              answerForm: _dropDownAnswer,
              isMultipleChoice: _isMultipleChoice,
              problemCount: _selectedCount,
            );
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
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      AppState().resetFavorites();
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
              side: BorderSide(width: 500),
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
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      AppState().resetWrong();
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
              side: BorderSide(width: 400),
            ),
          ),
          child: Text('오답 초기화', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
