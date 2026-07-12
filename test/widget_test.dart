import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_eyes/src/app.dart';

void main() {
  testWidgets('App shows AI EYES title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AIEyesApp()));

    expect(find.text('AI EYES'), findsOneWidget);
  });
}
