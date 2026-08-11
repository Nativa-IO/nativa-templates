import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets('home renders', (tester) async {
    await tester.pumpWidget(const NativaApp());
    expect(find.text('Nativa Flutter'), findsOneWidget);
  });
}
