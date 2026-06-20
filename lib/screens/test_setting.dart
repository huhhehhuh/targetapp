import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:targetapp/main.dart';

import 'test.dart';

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

int _rangeStart = 1;
int _rangeEnd = 400;

final List<int> _counts = [10, 30, 50, 80, 100, 200, 300, 400];
final List<int> _wordNumbers = List.generate(400, (index) => index + 1);

@override
void initState() {
super.initState();

final appState = Provider.of<AppState>(context, listen: false);

_dropDownFirst = appState.problemForm;
_dropDownLatter = appState.answerForm;
_isMultipleChoice = appState.isMultipleChoice;
_selectedCount = appState.problemCount;
}

void _showError(String message) {
showDialog(
context: context,
builder: (context) => AlertDialog(
title: const Text(
'오류',
style: TextStyle(color: Colors.red),
),
content: Text(message),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text('확인'),
),
 ],
),
);
}

List<int> _makeRangedVoca(List appStateVoca) {
return appStateVoca
.whereType<int>()
.where((wordNumber) {
return wordNumber >= _rangeStart && wordNumber <= _rangeEnd;
})
.toList();
}

@override
Widget build(BuildContext context) {
final outlineColor = Theme.of(context).colorScheme.outline;

return Scaffold(
appBar: AppBar(
title: const Text('시험지 설정'),
),
body: SafeArea(
child: SingleChildScrollView(
child: Center(
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
const SizedBox(height: 10),

const Text(
'시험 유형 설정',
style: TextStyle(fontSize: 24),
),

const SizedBox(height: 10),

Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text('문제:'),
const SizedBox(width: 10),

Container(
width: 110,
padding: const EdgeInsets.symmetric(horizontal: 8),
decoration: BoxDecoration(
border: Border.all(
color: outlineColor,
width: 1,
),
borderRadius: BorderRadius.circular(8),
),
child: DropdownButtonFormField<String>(
initialValue: _dropDownFirst,
items: ['한글단어', '영단어', '영영풀이']
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

const SizedBox(width: 15),
const Icon(Icons.arrow_forward_ios, size: 16),
const SizedBox(width: 15),

const Text('답안:'),
const SizedBox(width: 10),

Container(
width: 110,
padding: const EdgeInsets.symmetric(horizontal: 8),
decoration: BoxDecoration(
border: Border.all(
color: outlineColor,
width: 1,
),
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

const SizedBox(height: 10),

ToggleButtons(
borderRadius: BorderRadius.circular(20),
isSelected: [_isMultipleChoice, !_isMultipleChoice],
onPressed: (index) {
setState(() => _isMultipleChoice = index == 0);
},
children: ['객관식', '주관식']
.map(
(e) => Padding(
padding: const EdgeInsets.symmetric(horizontal: 12),
child: Text(e),
),
)
.toList(),
),

const SizedBox(height: 40),

const Text(
'번호 범위 설정',
style: TextStyle(fontSize: 24),
),

const SizedBox(height: 10),

const Text(
'선택한 번호 범위 안에서만 문제가 출제돼요.',
style: TextStyle(fontSize: 13),
),

const SizedBox(height: 10),

Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Container(
width: 95,
padding: const EdgeInsets.symmetric(horizontal: 8),
decoration: BoxDecoration(
border: Border.all(
color: outlineColor,
width: 1,
),
borderRadius: BorderRadius.circular(8),
),
child: DropdownButtonFormField<int>(
initialValue: _rangeStart,
items: _wordNumbers
.map(
(e) => DropdownMenuItem<int>(
value: e,
child: Text('$`e번'),
),
)
.toList(),
onChanged: (value) {
if (value == null) return;
setState(() => _rangeStart = value);
},
),
),

const SizedBox(width: 12),

const Text(
'~',
style: TextStyle(fontSize: 24),
),

const SizedBox(width: 12),

Container(
width: 95,
padding: const EdgeInsets.symmetric(horizontal: 8),
decoration: BoxDecoration(
border: Border.all(
color: outlineColor,
width: 1,
),
borderRadius: BorderRadius.circular(8),
),
child: DropdownButtonFormField<int>(
initialValue: _rangeEnd,
items: _wordNumbers
.map(
(e) => DropdownMenuItem<int>(
value: e,
child: Text('`$e번'),
),
)
.toList(),
onChanged: (value) {
if (value == null) return;
setState(() => _rangeEnd = value);
},
),
),
],
),

const SizedBox(height: 40),

const Text(
'문제 수 설정',
style: TextStyle(fontSize: 24),
),

const SizedBox(height: 10),

Column(
children: [
ToggleButtons(
constraints: const BoxConstraints(
maxWidth: 80,
minWidth: 80,
minHeight: 40,
),
isSelected: _counts
.sublist(0, 4)
.map((e) => e == _selectedCount)
.toList(),
onPressed: (index) {
setState(() => _selectedCount = _counts[index]);
},
borderRadius: BorderRadius.circular(8),
children:
_counts.sublist(0, 4).map((e) => Text(' e개')).toList(),
),
],
),

const SizedBox(height: 40),

ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.yellow,
foregroundColor: Colors.black,
textStyle: const TextStyle(fontSize: 18),
fixedSize: const Size(300, 50),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
onPressed: () {
if (_dropDownFirst == _dropDownLatter) {
_showError('문제 유형과 선지가 같을 수 없어요.');
return;
}

if (!_isMultipleChoice && _dropDownLatter != '영단어') {
_showError('주관식은 답안 유형이 영단어여야 해요.');
return;
}

if (_rangeStart <= 0 ||
_rangeStart >= 401 ||
_rangeEnd <= 0 ||
_rangeEnd >= 401) {
_showError('번호 범위는 1번부터 400번까지만 선택할 수 있어요.');
return;
}

if (_rangeStart >= _rangeEnd) {
_showError('시작 번호는 끝 번호보다 작아야 해요.');
return;
}

final appState = Provider.of<AppState>(
context,
listen: false,
);

final rangedVoca = _makeRangedVoca(appState.voca);

if (rangedVoca.isEmpty) {
_showError('선택한 범위에 출제할 단어가 없어요.');
return;
}

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
testList: appState.makeTest(
problemCount: _selectedCount,
isMultipleChoice: _isMultipleChoice,
testDomain: rangedVoca,
),
),
);
},
child: const Text('시작'),
),

const SizedBox(height: 30),
],
),
),
),
),
);
}
}