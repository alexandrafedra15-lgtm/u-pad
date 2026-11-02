import 'package:flutter_test/flutter_test.dart';
import 'package:upad/app.dart';

void main() {
  testWidgets('U-Pad App basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UPadApp());
    expect(find.byType(UPadApp), findsOneWidget);
  });
}
