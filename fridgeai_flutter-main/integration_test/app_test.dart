import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fridge_ai_flutter/src/views/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  group('end-to-end test', () {
    testWidgets('test home page',
            (tester) async {
              await tester.pumpWidget(const HomePage());


        });
  });
}