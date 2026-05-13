// lib/screens/target_view.dart
//내게는 고통밖에 없습니다.
//그것 말고는 아무것도 바라지 않습니다.
//고통은 내게 충실했고 그것은 지금도 변함이 없습니다.
//내 영혼이 심연의 바닥을 헤맬 때에도
//고통은 늘 곁에 앉아 나를 지켜주었으니 어떻게 고통을 원망하겠습니까.

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:provider/provider.dart';

import '../assets/target_voca_list.dart';
import 'package:targetapp/main.dart';

class TargetView extends StatefulWidget {
  const TargetView({super.key});

  @override
  State<TargetView> createState() => _TargetViewState();
}

class _TargetViewState extends State<TargetView> {
  @override
  Widget build(BuildContext context) {
    final String mode =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'all';

    final appState = context.watch<AppState>();

    final List<int> wordList;
    final String title;

    switch (mode) {
      case 'favorites':
        wordList = List<int>.from(appState.favorites)..sort();
        title = '즐겨찾기';
        break;

      case 'wrongs':
        final wrongEntries = appState.wrong.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        wordList = wrongEntries.map((entry) => entry.key).toList();
        title = '오답노트';
        break;

      case 'all':
      default:
        wordList = List<int>.from(appState.voca)..sort();
        title = '단어장';
        break;
    }

    final int maxWrongCount = appState.wrong.isEmpty
        ? 1
        : appState.wrong.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: wordList.isEmpty
          ? const Center(
              child: Text(
                '데이터가 없습니다',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: wordList.length,
              itemBuilder: (context, index) {
                final int wordNumber = wordList[index];

                final wordData = targetVoca[wordNumber];

                final String level = wordData[1].toString();
                final String word = wordData[2].toString();
                final String koreanMeaning = wordData[3].toString();
                final String englishMeaning = wordData[4].toString();

                final int wrongCount = appState.wrong[wordNumber] ?? 0;
                final double wrongRatio = wrongCount / maxWrongCount;

                final Color cardColor = mode == 'wrongs' && wrongCount > 0
                    ? Color.lerp(
                        const Color(0xFFE8F5E9),
                        const Color(0xFFFFEBEE),
                        wrongRatio,
                      )!
                    : Colors.white;

                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 52,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$wordNumber',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                level,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      word,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      appState.favorites.contains(wordNumber)
                                          ? Icons.star
                                          : Icons.star_border,
                                    ),
                                    onPressed: () {
                                      appState.toggleFavorite(wordNumber);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                koreanMeaning,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                englishMeaning,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.35,
                                  color: Colors.grey,
                                ),
                              ),
                              if (mode == 'wrongs') ...[
                                const SizedBox(height: 6),
                                Text(
                                  '$wrongCount회 틀림',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

@Preview()
Widget targetViewPreview() {
  return ChangeNotifierProvider(
    create: (_) => AppState(),
    child: const MaterialApp(home: TargetView()),
  );
}
