import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:targetapp/main.dart';

class TestSetting extends StatefulWidget {
  @Preview()
  const TestSetting({super.key});

  @override
  State<TestSetting> createState() => _TestSettingState();
}

class _TestSettingState extends State<TestSetting> {
  final _formKey = GlobalKey<FormState>();
  String? _dropDownFirst = AppState().problemForm;
  String? _dropDownLatter = AppState().answerForm;
  bool _isMultipleChoice = AppState().isMultipleChoice;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //시험 유형 설정
          Text('시험 유형 설정', style: TextStyle(fontSize: 24),),
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
                  validator: (v) {
                    if (v == _dropDownLatter) return '문제 유형과 선지가 같을 수 없어요.';
                    return null;
                  },
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

              SizedBox(width: 30),
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
            ],
          ),

          //문제수 설정
          // Text('문제 수 설정', style: TextStyle(fontSize: 24)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ToggleButtons(
          //       children: children, 
          //       isSelected: isSelected
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
