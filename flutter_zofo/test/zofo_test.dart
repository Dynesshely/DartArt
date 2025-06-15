// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutter_zofo/framework.dart';

void main() {
  test('basic flow', () async {
    WidgetsFlutterBinding.ensureInitialized();

    await zofo.initAsync();

    runApp(TestApp());
  });

  // test('adds one to input values', () {
  //   final calculator = Calculator();
  //   expect(calculator.addOne(2), 3);
  //   expect(calculator.addOne(-7), -6);
  //   expect(calculator.addOne(0), 1);
  // });
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Flutter Zofo Test', home: Scaffold(body: Center(child: Text('Hello, Flutter Zofo!'))));
  }
}
