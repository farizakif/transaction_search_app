// Basic Flutter widget test for Transaction Search App.

import 'package:flutter_test/flutter_test.dart';

import 'package:transaction_search_app/main.dart';

void main() {
  testWidgets('Search screen loads with correct title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TransactionSearchApp());

    // Verify that the Search screen loads with correct app bar title.
    expect(find.text('Transaction Search'), findsOneWidget);
  });
}
