import 'package:flutter/material.dart';

class Home extends StatelessWidget {
const Home({super.key});

void goToTargetView(BuildContext context, String mode) {
Navigator.pushNamed(
context,
'/targetview',
arguments: mode,
);
}

void goToPage(BuildContext context, String routeName) {
Navigator.pushNamed(context, routeName);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Target'),
centerTitle: true,
),
body: SafeArea(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
const SizedBox(height: 30),

const Text(
'Target',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 42,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

const Text(
'영단어 내신 대비',
textAlign: TextAlign.center,
style: TextStyle(fontSize: 16),
),

const SizedBox(height: 50),

HomeButton(
text: '단어장',
onPressed: () => goToTargetView(context, 'all'),
),

HomeButton(
text: '문제풀기',
onPressed: () => goToPage(context, '/testsetting'),
),

HomeButton(
text: '즐겨찾기',
onPressed: () => goToTargetView(context, 'favorites'),
),

HomeButton(
text: '오답노트',
onPressed: () => goToTargetView(context, 'wrong'),
),

HomeButton(
text: '설정',
onPressed: () => goToPage(context, '/setting'),
),
],
),
),
),
);
}
}

class HomeButton extends StatelessWidget {
final String text;
final VoidCallback onPressed;

const HomeButton({
super.key,
required this.text,
required this.onPressed,
});

@override
Widget build(BuildContext context) {
return Padding(
padding: const EdgeInsets.only(bottom: 14),
child: SizedBox(
height: 56,
child: ElevatedButton(
onPressed: onPressed,
child: Text(
text,
style: const TextStyle(fontSize: 18),
),
),
),
);
}
}