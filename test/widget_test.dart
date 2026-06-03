// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:archival/main.dart';
import 'package:archival/models/app_state.dart';

void main() {
  testWidgets('App loads and shows Archival title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const ArchivalApp(),
      ),
    );

    // Verify that the app title 'Archival' is shown.
    expect(find.textContaining('Archival'), findsAtLeastNWidgets(1));
    
    // Verify that the Today screen greeting or mood section is present.
    expect(find.text("Today's mood"), findsOneWidget);
  });
}
