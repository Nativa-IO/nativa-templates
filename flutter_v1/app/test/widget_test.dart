import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('welcome screen renders', (tester) async {
    await tester.pumpWidget(const NativaApp());
    expect(find.text('Nativa'), findsOneWidget);
    expect(find.text('App corriendo ✓'), findsOneWidget);
  });
}
