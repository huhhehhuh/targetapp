import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// HomeMenuButton : 재사용 가능한 정사각형 메뉴 버튼 위젯
//
// Flutter에서는 반복되는 UI 요소를 별도의 위젯(클래스)으로 분리해두면
// 코드 중복 없이 파라미터만 바꿔서 여러 곳에 재사용할 수 있다.
//
// StatelessWidget : 내부 상태(state)가 없는 위젯.
//   → 한 번 그려지면 스스로 바뀌지 않는 UI에 사용한다.
//   → 반대 개념은 StatefulWidget (카운터, 입력값 등 변하는 UI에 사용)
// ──────────────────────────────────────────────────────────────────────────────
class HomeMenuButton extends StatelessWidget {
  // final : 한 번 할당하면 바꿀 수 없는 값. 위젯이 그려진 후 변경되지 않으므로 final로 선언.
  final String label;       // 버튼에 표시할 텍스트
  final IconData icon;      // 버튼에 표시할 아이콘 (Icons.xxx 형태로 전달)
  final Color color;        // 버튼 배경 색상
  final Color iconColor;    // 아이콘/텍스트 색상
  final VoidCallback onTap; // 버튼을 눌렀을 때 실행할 함수
                            // VoidCallback = 매개변수도 없고 반환값도 없는 함수 타입 () => void

  // const 생성자 : 컴파일 타임에 값이 결정되어 성능상 유리하다.
  // required : 이 파라미터는 반드시 전달해야 한다는 의미 (없으면 컴파일 에러)
  const HomeMenuButton({
    super.key,         // Flutter 내부에서 위젯을 식별하는 고유 키. super = 부모클래스(StatelessWidget)에 전달
    required this.label,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  // StatelessWidget을 상속하면 반드시 build() 메서드를 구현해야 한다.
  // build()는 이 위젯이 화면에 어떻게 그려질지를 정의한다.
  // BuildContext : 위젯 트리에서 이 위젯의 위치 정보를 담고 있는 객체
  @override
  Widget build(BuildContext context) {

    // GestureDetector : 시각적 요소 없이 터치 이벤트만 감지하는 투명한 래퍼 위젯
    // onTap 외에도 onLongPress(꾹 누르기), onDoubleTap(두 번 탭) 등도 지원한다.
    return GestureDetector(
      onTap: onTap, // 탭(짧게 누르기) 이벤트 발생 시 onTap 함수 실행

      // Container : Flutter의 만능 박스 위젯
      // 크기, 색상, 패딩, 마진, 테두리, 그림자 등 대부분의 시각적 스타일을 담당한다.
      child: Container(

        // decoration : Container의 외형을 꾸미는 속성.
        // color 속성과 decoration을 동시에 쓰면 에러가 나므로, 색상도 decoration 안에 넣는다.
        decoration: BoxDecoration(
          color: color, // 버튼 배경색 (파라미터로 전달받은 값)

          // borderRadius : 모서리를 얼마나 둥글게 할지 설정
          // BorderRadius.circular(24) → 모든 모서리를 반지름 24px로 둥글게
          borderRadius: BorderRadius.circular(24),
        ),

        // Column : 자식 위젯들을 세로(수직) 방향으로 나열하는 레이아웃 위젯
        // 반대 개념은 Row (가로 방향 나열)
        child: Column(
          // mainAxisAlignment : Column의 주축(세로) 방향 정렬 방식
          // center → 세로 방향 가운데 정렬
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Icon : Flutter에서 기본 제공하는 머티리얼 아이콘을 표시하는 위젯
            Icon(icon, size: 40, color: iconColor),

            // SizedBox : 고정된 크기의 빈 공간을 만드는 위젯
            // 위젯 사이 여백을 줄 때 Padding 대신 자주 사용한다.
            const SizedBox(height: 10),

            // Text : 텍스트를 화면에 표시하는 위젯
            Text(
              label,
              textAlign: TextAlign.center, // 텍스트 내부 정렬 (줄바꿈 시 가운데 정렬)
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700, // 굵기. w100(얇음) ~ w900(굵음)
                color: iconColor,
                height: 1.3, // 줄간격 배수 (폰트 크기 × 1.3)
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ──────────────────────────────────────────────────────────────────────────────
// Home : 앱의 메인 홈 화면
// ──────────────────────────────────────────────────────────────────────────────
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    // Scaffold : 앱 화면의 기본 뼈대를 제공하는 위젯
    // AppBar(상단바), body(본문), BottomNavigationBar(하단바),
    // FloatingActionButton 등을 배치할 수 있는 템플릿이다.
    return Scaffold(
      // SafeArea : 노치(카메라 홈), 상태바, 하단 홈 바 등 OS가 점유하는 영역을 피해서
      // 자식 위젯을 안전한 영역 안에만 그려준다.
      // 이걸 쓰지 않으면 콘텐츠가 노치에 가려질 수 있다.
      body: SafeArea(

        // Padding : 자식 위젯 주변에 여백을 추가하는 위젯
        // EdgeInsets.symmetric : 가로(horizontal)/세로(vertical) 방향으로 대칭 여백 설정
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

          // Column : 자식들을 세로로 나열
          child: Column(
            // crossAxisAlignment : Column의 교차축(가로) 방향 정렬
            // stretch → 자식들을 가로로 꽉 늘린다 (부모 너비만큼)
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              // ── 로고 영역 ──────────────────────────────────────────────────
              _buildLogo(),
              const SizedBox(height: 32),

              // ── 2×2 그리드 버튼 ────────────────────────────────────────────
              // Expanded : Column/Row 안에서 남은 공간을 모두 차지하도록 자식을 늘려주는 위젯
              // 여기서 GridView가 로고와 설정버튼을 제외한 나머지 공간을 전부 사용하게 된다.
              // Expanded 없이 GridView를 쓰면 "높이를 알 수 없다"는 에러가 발생한다.
              Expanded(

                // GridView.count : 열(column) 개수를 고정해서 격자형 레이아웃을 만드는 위젯
                // crossAxisCount: 2 → 한 줄에 2개씩 배치
                child: GridView.count(
                  crossAxisCount: 2,      // 열 개수
                  crossAxisSpacing: 16,   // 열 사이 가로 간격 (px)
                  mainAxisSpacing: 16,    // 행 사이 세로 간격 (px)

                  // NeverScrollableScrollPhysics : GridView 자체의 스크롤을 비활성화
                  // 부모 Column이 스크롤을 담당하게 하거나, 스크롤 자체가 필요없을 때 사용
                  physics: const NeverScrollableScrollPhysics(),

                  // children : GridView에 들어갈 위젯 목록
                  // 위에서 만든 HomeMenuButton을 파라미터만 다르게 해서 4번 재사용
                  children: [
                    HomeMenuButton(
                      label: 'Target\n단어장', // \n = 줄바꿈 문자
                      icon: Icons.menu_book_rounded,
                      color: const Color(0xFF4F8EF7),
                      iconColor: Colors.white,
                      // Navigator.pushNamed : 라우트 이름('/vocabulary')으로 화면 전환
                      // context가 필요한 이유: Navigator는 위젯 트리를 통해 동작하기 때문
                      onTap: () => Navigator.pushNamed(context, '/vocabulary'),
                    ),
                    HomeMenuButton(
                      label: '문제풀기',
                      icon: Icons.edit_note_rounded,
                      color: const Color(0xFF43C88B),
                      iconColor: Colors.white,
                      onTap: () => Navigator.pushNamed(context, '/quiz'),
                    ),
                    HomeMenuButton(
                      label: '즐겨찾기',
                      icon: Icons.star_rounded,
                      color: const Color(0xFFFFB74D),
                      iconColor: Colors.white,
                      onTap: () => Navigator.pushNamed(context, '/favorites'),
                    ),
                    HomeMenuButton(
                      label: '틀린문제',
                      icon: Icons.replay_rounded,
                      color: const Color(0xFFEF5350),
                      iconColor: Colors.white,
                      onTap: () => Navigator.pushNamed(context, '/wrong'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── 설정 버튼 ──────────────────────────────────────────────────
              _buildSettingsButton(context),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }


  // ── 로고 위젯을 별도 메서드로 분리 ──────────────────────────────────────────
  // build() 메서드가 너무 길어지지 않도록, 독립적인 UI 덩어리는 이렇게 private 메서드로 분리한다.
  // 메서드 이름 앞의 _ (언더스코어) = Dart에서 private을 의미 (이 파일 안에서만 접근 가능)
  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(

        // gradient : 두 가지 이상의 색을 자연스럽게 섞어주는 효과
        // LinearGradient : 직선 방향으로 색이 변하는 그라디언트
        gradient: const LinearGradient(
          colors: [Color(0xFF4F8EF7), Color(0xFF1A5FD6)], // 시작색 → 끝색
          begin: Alignment.topLeft,   // 그라디언트 시작 위치
          end: Alignment.bottomRight, // 그라디언트 끝 위치
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F8EF7).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      // Row : 자식 위젯들을 가로(수평) 방향으로 나열
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center, // 가로 방향 가운데 정렬
        children: [
          Icon(Icons.auto_stories_rounded, color: Colors.white, size: 28),
          SizedBox(width: 10), // Row 안에서는 width로 가로 여백을 준다
          Text(
            'TARGET',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 4, // 글자 사이 간격 (자간)
            ),
          ),
        ],
      ),
    );
  }


  // ── 설정 버튼 위젯을 별도 메서드로 분리 ────────────────────────────────────
  // context를 Navigator에서 사용해야 하므로 파라미터로 받는다.
  Widget _buildSettingsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/settings'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF3D3D3D),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings_rounded, color: Colors.white70, size: 22),
            SizedBox(width: 8),
            Text(
              '설정',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}