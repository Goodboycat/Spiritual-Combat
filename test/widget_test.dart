import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:combate_espiritual/main.dart';

void main() {
  testWidgets('App loads without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const CombateEspiritualApp());
    await tester.pumpAndSettle();
    
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
