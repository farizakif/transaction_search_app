import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_search_app/main.dart';

void main() {
  testWidgets('Search screen loads with correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const TransactionSearchApp());

    expect(find.text('Transaction Search'), findsOneWidget);
  });
}
