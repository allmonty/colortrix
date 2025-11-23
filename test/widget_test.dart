import 'package:flutter_test/flutter_test.dart';
import 'package:colortrix/main.dart';

void main() {
  testWidgets('App starts and shows upload button', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.text('Upload Image'), findsOneWidget);
  });
}
