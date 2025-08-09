import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_stock/main.dart';

void main() {
  testWidgets('HomeScreen shows title and FAB', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the home screen title appears.
    expect(find.text('My Shareholder Benefits'), findsOneWidget);

    // Ensure that a FloatingActionButton is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
