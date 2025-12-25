import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const TargetApp());
}

class TargetApp extends StatelessWidget {
  const TargetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Target App',
        routes: {
          '/': (context) => const HomePage(),
          '/targetview': (context) => const TargetView(),
          '/testsetting': (context) => const TestSetting(),
          '/setting': (context) => const Setting(),
          '/test': (context) => const Test(),
          '/result': (context) => const Result(),
        },
      ),
    );
  }
}

class Pair implements Comparable<Pair> {
  final int x;
  final int y;
  const Pair(this.x, this.y);

  @override
  int compareTo(Pair other) {
    final byX = other.x.compareTo(x); //x에 대하여 내림차순
    if (byX != 0) return byX;
    return y.compareTo(other.y); // y에 대하여 오름차순
  }
}

class AppState extends ChangeNotifier {
  int _rangeStart = 1, _rangeEnd = 6493;
  int get rangeStart => _rangeStart;
  int get rangeEnd => _rangeEnd;
  final List<bool> favorites = List.filled(6493, false); // 0번부터 시작
  final List<Pair> wrongs = List.generate(
    6493,
    (i) => Pair(0, i),
  ); // (틀린횟수, 번호)
  final List<int> viewNumbers = [];
  String _precondition = '';

  void makeViewList(String p) {
    if (_precondition == p) return;
    if (p == 'Everything') {
      _precondition = 'Everything';
      for (int i = _rangeStart - 1; i < _rangeEnd; i++) {
        viewNumbers.add(i);
      }
    } else if (p == 'Favorites') {
      _precondition = 'Favorites';
      for (int i = 0; i < 6493; i++) {
        if (favorites[i] == true) {
          viewNumbers.add(i);
        }
      }
    } else {
      _precondition = 'Wrongs';
      final sorted = wrongs.sort();
      for (int i = 0; i < wrongs.length; i++) {
        if (wrongs[i].x == 0) break;
        viewNumbers.add(wrongs[i].y);
      }
    }
  }

  void ToggleFavorites(int p) {
    favorites[p] = !favorites[p];
    notifyListeners();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                appState.makeViewList('Everything');
                Navigator.pushNamed(
                  context,
                  '/targetview',
                  arguments: 'Target',
                );
              },
              child: const Text('Target\n보기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/testsetting');
              },
              child: const Text('문제풀기'),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                appState.makeViewList('Favorites');
                Navigator.pushNamed(context, '/targetview', arguments: '즐겨찾기');
              },
              child: const Text('즐겨찾기'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.makeViewList('Wrongs');
                Navigator.pushNamed(context, '/targetview', arguments: '틀린문제');
              },
              child: const Text('틀린문제'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/setting');
          },
          child: const Text('설정'),
        ),
      ],
    );
  }
}

class TargetView extends StatelessWidget {
  const TargetView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final String title = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.builder(
        itemCount: appState.viewNumbers.length,
        itemBuilder: (context, index) {
          final number = appState.viewNumbers[index];
          return _WordRow(number: number);
        },
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final int number;
  const _WordRow({required this.number});

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select<AppState, bool>(
      (s) => s.favorites[number],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.read<AppState>().ToggleFavorites(number),
            icon: Icon(isFavorite ? Icons.star : Icons.star_border),
          ),
          //단어 + 뜻 + 영영풀이
          // Expanded(
          //   flex: 2,
          //   child: Text(''),
          // ),
          // Expanded(
          //   flex: 5,
          //   child: Text('$number'),
          // ),
        ],
      ),
    );
  }
}

class TestSetting extends StatefulWidget {
  const TestSetting({super.key});

  @override
  State<TestSetting> createState() => _TestSettingState();
}

class _TestSettingState extends State<TestSetting> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Result extends StatefulWidget {
  const Result({super.key});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
