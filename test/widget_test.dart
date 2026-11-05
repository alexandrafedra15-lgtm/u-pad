import 'package:flutter_test/flutter_test.dart';
import 'package:upad/app.dart';

void main() {
  testWidgets('Equilibra-U App basic smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const UPadApp());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(UPadApp), findsOneWidget);
  });
}
