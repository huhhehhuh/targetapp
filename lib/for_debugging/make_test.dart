import 'package:flutter_test/flutter_test.dart';
import 'package:targetapp/main.dart'; // AppState가 있는 파일

void main() {
  test('makeTest 객관식', () {
    final state = AppState();
    final result = state.makeTest(problemCount: 5, isMultipleChoice: true);
    
    print(result); // 구조 확인
    expect(result.length, 5);           // 문제 수
    expect(result[0].length, 7);        // [문제, 선지5개, 정답인덱스]
  });

  test('makeTest 주관식', () {
    final state = AppState();
    final result = state.makeTest(problemCount: 5, isMultipleChoice: false);
    
    print(result);
    expect(result.length, 5);
    expect(result[0].length, 1);        // [문제번호]만
  });
}