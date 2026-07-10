import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sibi_ai/main.dart';

void main() {
  testWidgets('App login and transition to dashboard test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SibiAiApp());

    // Enter email and password
    await tester.enterText(find.byType(TextFormField).first, 'guru@sibi.sch.id');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.pump();

    // Tap the login button
    await tester.tap(find.text('Masuk ke Dashboard'));
    
    // Pump and wait for the simulated network delay (1000ms)
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();

    // Verify we have transitioned to the Dashboard screen
    expect(find.text('Dashboard Utama'), findsOneWidget);
  });
}
