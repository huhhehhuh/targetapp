// lib/screens/target_view.dart
//아 정신나갈거같애
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
    // Home에서 넘긴 arguments 받기
    // all / favorites / wrongs 중 하나가 들어옴
    final String mode =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'all';

    // Provider에서 AppState 가져오기
    final appState = context.watch<AppState>();

    // mode에 따라 보여줄 리스트와 제목 결정
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
        // 전체 6000개가 아니라 현재 시험범위(appState.voca)만 보여줌
        wordList = List<int>.from(appState.voca)..sort();
        title = '단어장';
        break;
    }

    // 오답노트 색깔 계산용: 가장 많이 틀린 횟수
    final int maxWrongCount = appState.wrong.isEmpty
        ? 1
        : appState.wrong.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
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
                        const Color(0xFFE8F5E9), // 은은한 초록
                        const Color(0xFFFFEBEE), // 은은한 빨강
                        wrongRatio,
                      )!
                    : Colors.white;

                return Card(
                  color: cardColor,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 48,
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
                    title: Text(
                      word,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          koreanMeaning,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          englishMeaning,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        if (mode == 'wrongs') ...[
                          const SizedBox(height: 4),
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
                    trailing: IconButton(
                      icon: Icon(
                        appState.favorites.contains(wordNumber)
                            ? Icons.star
                            : Icons.star_border,
                      ),
                      onPressed: () {
                        appState.toggleFavorite(wordNumber);
                      },
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