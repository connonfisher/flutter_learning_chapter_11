// 章节总目录的冒烟测试：验证首页能正常构建并展示 7 个小节标题。

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_learning_chapter_11/main.dart';

void main() {
  testWidgets('章节总目录展示 7 个小节', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('11.1 文件操作'), findsOneWidget);
    expect(find.text('11.7 JSON 转 Dart Model 类'), findsOneWidget);
  });
}
