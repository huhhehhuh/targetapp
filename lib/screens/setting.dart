import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:targetapp/main.dart';

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
late String _themeModeName;

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
_themeModeName = appState.themeModeName;
}

void _showError(String message) {
showDialog(
context: context,
builder: (BuildContext context) => AlertDialog(
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

@override
Widget build(BuildContext context) {
final outlineColor = Theme.of(context).colorScheme.outline;

return Scaffold(
appBar: AppBar(
title: const Text('설정'),
),
body: SafeArea(
child: SingleChildScrollView(
child: Center(
child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
const SizedBox(height: 10),

Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
'학년:',
style: TextStyle(fontSize: 16),
),
const SizedBox(width: 10),
DropdownButton<int>(
value: _selectedGrade,
items: [1, 2, 3]
.map(
(e) => DropdownMenuItem<int>(
value: e,
child: Text('$`e학년'),
),
)
.toList(),
onChanged: (value) {
setState(() => _selectedGrade = value);
},
),
],
),

const SizedBox(height: 30),

const Text(
'화면 테마',
style: TextStyle(fontSize: 16),
),

const SizedBox(height: 10),

ToggleButtons(
borderRadius: BorderRadius.circular(20),
isSelected: [
_themeModeName == 'system',
_themeModeName == 'light',
_themeModeName == 'dark',
 ],
onPressed: (index) {
setState(() {
if (index == 0) {
_themeModeName = 'system';
} else if (index == 1) {
_themeModeName = 'light';
} else {
_themeModeName = 'dark';
}
});
},
children: const [
Padding(
padding: EdgeInsets.symmetric(horizontal: 12),
child: Text('시스템'),
),
Padding(
padding: EdgeInsets.symmetric(horizontal: 12),
child: Text('라이트'),
),
Padding(
padding: EdgeInsets.symmetric(horizontal: 12),
child: Text('다크'),
),
 ],
),

const SizedBox(height: 30),

const Text(
'기본 세팅 설정',
style: TextStyle(fontSize: 16),
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
initialValue: _dropDownProblem,
items: ['한글단어', '영단어', '영영풀이']
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

const SizedBox(height: 20),

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

const SizedBox(height: 30),

const Text(
'문제 수',
style: TextStyle(fontSize: 16),
),

const SizedBox(height: 10),

Column(
crossAxisAlignment: CrossAxisAlignment.center,
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
_counts.sublist(0, 4).map((e) => Text('`$e개')).toList(),
),
ToggleButtons(
constraints: const BoxConstraints(
maxWidth: 80,
minWidth: 80,
minHeight: 40,
),
isSelected: _counts
.sublist(4, 8)
.map((e) => e == _selectedCount)
.toList(),
onPressed: (index) {
setState(() => _selectedCount = _counts[index + 4]);
},
borderRadius: BorderRadius.circular(8),
children:
_counts.sublist(4, 8).map((e) => Text('$e개')).toList(),
),
],
),

const SizedBox(height: 20),

ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.green,
foregroundColor: Colors.white,
fixedSize: const Size(300, 50),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
onPressed: () async {
if (_dropDownProblem == _dropDownAnswer) {
_showError('문제와 답안의 유형이 같을 수 없어요.');
return;
}

if (!_isMultipleChoice && _dropDownAnswer != '영단어') {
_showError('주관식은 답안 유형이 영단어여야 해요.');
return;
}

final appState = Provider.of<AppState>(
context,
listen: false,
);

await appState.saveSettings(
grade: _selectedGrade,
problemForm: _dropDownProblem,
answerForm: _dropDownAnswer,
isMultipleChoice: _isMultipleChoice,
problemCount: _selectedCount,
themeModeName: _themeModeName,
);

if (!context.mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('설정이 저장되었어요.'),
duration: Duration(seconds: 2),
),
);

Navigator.pushNamedAndRemoveUntil(
context,
'/',
(route) => false,
);
},
child: const Text(
'저장',
style: TextStyle(fontSize: 16),
),
),

const SizedBox(height: 30),

ElevatedButton(
onPressed: () {
showDialog(
context: context,
builder: (context) => AlertDialog(
title: const Text('초기화'),
content: const Text('즐겨찾기를 초기화하시겠습니까?'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text('취소'),
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
child: const Text('확인'),
),
],
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor: Colors.white,
fixedSize: const Size(300, 50),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
child: const Text(
'즐겨찾기 초기화',
style: TextStyle(fontSize: 16),
),
),

const SizedBox(height: 10),

ElevatedButton(
onPressed: () {
showDialog(
context: context,
builder: (context) => AlertDialog(
title: const Text('초기화'),
content: const Text('오답을 초기화하시겠습니까?'),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text('취소'),
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
child: const Text('확인'),
),
],
),
);
},
style: ElevatedButton.styleFrom(
backgroundColor: Colors.red,
foregroundColor: Colors.white,
fixedSize: const Size(300, 50),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
child: const Text(
'오답 초기화',
style: TextStyle(fontSize: 16),
),
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
