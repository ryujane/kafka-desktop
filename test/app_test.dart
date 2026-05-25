import 'package:flutter_test/flutter_test.dart';
import 'package:kafkax/app.dart';

void main() {
  testWidgets('App renders without error', (tester) async {
    await tester.pumpWidget(const KafkaXApp());
    await tester.pumpAndSettle();
    expect(find.byType(KafkaXApp), findsOneWidget);
  });
}
