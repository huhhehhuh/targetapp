// lib/screens/target_view.dart

import 'package:flutter/widget_previews.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// main.dart에 있는 AppState를 가져옴
// 프로젝트 이름이 다르면 패키지명 확인 후 수정 필요
import 'package:targetapp/main.dart'; // ← 본인 프로젝트 패키지명으로 변경

class TargetView extends StatefulWidget {
  const TargetView({super.key});

  @override
  State<TargetView> createState() => _TargetViewState();
}

class _TargetViewState extends State<TargetView> {
  @override
  Widget build(BuildContext context) {

    // ─────────────────────────────────────────────
    // [1] arguments 받기
    //
    // Navigator.pushNamed(context, '/targetview', arguments: 'all') 처럼
    // 이동할 때 넘긴 arguments를 여기서 꺼냄.
    //
    // ModalRoute.of(context)를 쓰는 이유:
    //   Flutter의 화면 이동(라우팅)은 "Route"라는 객체로 관리됨.
    //   ModalRoute.of(context)는 "지금 내가 있는 화면의 Route"를 가져오는 것.
    //   거기서 .settings.arguments로 넘겨받은 데이터를 읽을 수 있음.
    //   생성자(constructor)로 받지 않는 이유는, pushNamed 방식에서는
    //   arguments를 생성자로 전달하기 어렵기 때문.
    // ─────────────────────────────────────────────
    final String mode =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? 'all';
    //   ↑ arguments가 null이면 기본값 'all'로 처리


    // ─────────────────────────────────────────────
    // [2] AppState 가져오기 - context.watch 사용
    //
    // context.watch vs context.read 차이:
    //
    //   context.watch<AppState>()
    //     → AppState가 바뀔 때마다 이 위젯을 자동으로 다시 그림(rebuild)
    //     → 화면에 데이터를 "보여줄 때" 사용
    //
    //   context.read<AppState>()
    //     → 상태를 딱 한 번만 읽음. 변경돼도 화면 안 바뀜.
    //     → 버튼 onPressed처럼 "동작할 때" 사용
    //
    //   지금은 리스트를 화면에 보여줘야 하므로 watch 사용
    // ─────────────────────────────────────────────
    final appState = context.watch<AppState>();


    // ─────────────────────────────────────────────
    // [3] mode에 따라 데이터 선택
    // ─────────────────────────────────────────────
    final List<int> wordList;
    final String title;

    switch (mode) {
  case 'favorites':
    wordList = List<int>.from(appState.favorites)..sort();
    title = '즐겨찾기';
    break;

  case 'wrong':
    wordList = List<int>.from(appState.wrong)..sort();
    title = '오답노트';
    break;

  case 'all':
  default:
    wordList = List<int>.from(appState.voca)..sort();
    title = '단어장';
    break;
}


    // ─────────────────────────────────────────────
    // [4] 화면 구성
    // ─────────────────────────────────────────────
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // mode에 따라 제목 바뀜
      ),

      // ─────────────────────────────────────────────
      // [5] 빈 리스트 처리
      //     데이터가 없으면 안내 문구, 있으면 리스트 출력
      // ─────────────────────────────────────────────
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

                return ListTile(
                  // 나중에 실제 단어 텍스트 연결 예정
                  // 지금은 단어 번호만 표시
                  title: Text('단어 $wordNumber'),
                  leading: Text(
                    '${index + 1}', // 순서 번호 (1부터 시작)
                    style: const TextStyle(color: Colors.grey),
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
    child: const MaterialApp(
      home: TargetView(),
    ),
  );
}