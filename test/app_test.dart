import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kafkax/app.dart';
import 'package:kafkax/presentation/providers/connection_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App renders without error', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(AsyncData(prefs)),
        ],
        child: const KafkaXApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(KafkaXApp), findsOneWidget);
  });
}
