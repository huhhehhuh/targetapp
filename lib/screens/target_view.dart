import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assets/target_voca_list.dart';
import 'package:targetapp/main.dart';

class TargetView extends StatefulWidget {
  const TargetView({super.key});

  @override
  State<TargetView> createState() => _TargetViewState();
}

class _TargetViewState extends State<TargetView> {
  String _searchKeyword = '';

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

        wordList = wrongEntries.map<int>((entry) => entry.key).toList();
        title = '오답노트';
        break;

      case 'all':
      default:
        wordList = List<int>.from(appState.voca)..sort();
        title = '단어장';
        break;
    }

    final List<int> filteredWordList = wordList.where((wordNumber) {
      final wordData = targetVoca[wordNumber];
      final String word = wordData[2].toString().toLowerCase();
      final String keyword = _searchKeyword.trim().toLowerCase();

      if (keyword.isEmpty) {
        return true;
      }

      return word.contains(keyword);
    }).toList();

    final int maxWrongCount = appState.wrong.isEmpty
        ? 1
        : appState.wrong.values.reduce((a, b) => a > b ? a : b);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color baseCardColor =
        isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final Color primaryTextColor =
        isDark ? Colors.white : const Color(0xFF222222);

    final Color secondaryTextColor =
        isDark ? Colors.white70 : const Color(0xFF666666);

    final Color mutedTextColor =
        isDark ? Colors.white60 : const Color(0xFF888888);

    final Color searchFillColor =
        isDark ? const Color(0xFF1A1A1A) : Colors.white;

    final Color wrongCountTextColor =
        isDark ? const Color(0xFFFF8A80) : Colors.redAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: wordList.isEmpty
          ? Center(
              child: Text(
                '데이터가 없습니다',
                style: TextStyle(
                  fontSize: 16,
                  color: mutedTextColor,
                ),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    style: TextStyle(color: primaryTextColor),
                    decoration: InputDecoration(
                      hintText: '영어 단어 검색',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      prefixIcon: Icon(
                        Icons.search,
                        color: secondaryTextColor,
                      ),
                      filled: true,
                      fillColor: searchFillColor,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchKeyword = value;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: filteredWordList.isEmpty
                      ? Center(
                          child: Text(
                            '검색 결과가 없습니다',
                            style: TextStyle(
                              fontSize: 16,
                              color: mutedTextColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredWordList.length,
                          itemBuilder: (context, index) {
                            final int wordNumber = filteredWordList[index];
                            final wordData = targetVoca[wordNumber];

                            final String level = wordData[1].toString();
                            final String word = wordData[2].toString();
                            final String koreanMeaning =
                                wordData[3].toString();
                            final String englishMeaning =
                                wordData[4].toString();

                            final int wrongCount =
                                appState.wrong[wordNumber] ?? 0;

                            final double wrongRatio =
                                wrongCount / maxWrongCount;

                            final Color cardColor =
                                mode == 'wrongs' && wrongCount > 0
                                    ? Color.lerp(
                                        isDark
                                            ? const Color(0xFF1F3B24)
                                            : const Color(0xFFE8F5E9),
                                        isDark
                                            ? const Color(0xFF4A1F24)
                                            : const Color(0xFFFFEBEE),
                                        wrongRatio,
                                      )!
                                    : baseCardColor;

                            final bool isFavorite =
                                appState.favorites.contains(wordNumber);

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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: mutedTextColor,
                                            ),
                                          ),
                                          Text(
                                            level,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: mutedTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  word,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: primaryTextColor,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: isFavorite
                                                      ? Colors.amber
                                                      : secondaryTextColor,
                                                ),
                                                onPressed: () {
                                                  appState.toggleFavorite(
                                                    wordNumber,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            koreanMeaning,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              height: 1.45,
                                              color: primaryTextColor,
                                            ),
                                          ),

                                          const SizedBox(height: 6),

                                          Text(
                                            englishMeaning,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 13,
                                              height: 1.35,
                                              color: secondaryTextColor,
                                            ),
                                          ),

                                          if (mode == 'wrongs') ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              '$wrongCount회 틀림',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: wrongCountTextColor,
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
                ),
              ],
            ),
    );
  }
}
