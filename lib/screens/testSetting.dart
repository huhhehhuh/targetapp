import 'package:flutter/material.dart';
// import 'package:flutter/widget_previews.dart';
import 'package:targetapp/main.dart';

class TestSetting extends StatefulWidget {
  const TestSetting({super.key});

  @override
  State<TestSetting> createState() => _TestSettingState();
}

class _TestSettingState extends State<TestSetting> {
  String? _dropDownFirst = AppState().problemForm;
  String? _dropDownLatter = AppState().answerForm;
  bool _isMultipleChoice = AppState().isMultipleChoice;
  int _selectedCount = AppState().problemCount;
  final List<int> _counts = [10, 30, 50, 80, 100, 200, 300, 400];

  @override
  Widget build(BuildContext context) {
    return Column(
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
                width: 100,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: _dropDownFirst,
                  items: ['한글단어', '영단어', '영영풀이', '문장']
                      .map(
                        (e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _dropDownFirst = value);
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
                  initialValue: _dropDownLatter,
                  items: ['한글단어', '영단어', '영영풀이']
                      .map(
                        (e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)),
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

          SizedBox(height: 80),

          //문제수 설정
          Text('문제 수 설정', style: TextStyle(fontSize: 24)),
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

          SizedBox(height: 40),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_dropDownFirst == _dropDownLatter) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('오류'),
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
              },
              child: Text('시작'),
            ),
          ),
        ],
    );
  }
}