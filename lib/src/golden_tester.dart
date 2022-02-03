import 'package:flutter/widgets.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

abstract class GoldenTesterBase {
  GoldenTesterBase({
    required Widget Function(Key key) widget,
    required Widget Function(Widget) wrapper,
    this.testName = '',
  })  : _widget = widget,
        _wrapper = wrapper,
        _key = UniqueKey();

  final String folder = 'golden';

  final Key _key;

  final Widget Function(Key key) _widget;
  final Widget Function(Widget) _wrapper;

  final String testName;
  late String scenarioName;
  late WidgetTester tester;
  Device? device;

  @mustCallSuper
  Future<void> setScenario({
    required WidgetTester tester,
    required String scenarioName,
    Device? device,
  }) async {
    this.tester = tester;
    this.scenarioName = scenarioName;
    this.device = device;
    await tester.pumpWidget(_wrapper(_widget(_key)));
  }

  Future<void> matchesGolden() async {
    final dot = testName.isEmpty ? '' : '.';
    final deviceName = device == null ? '' : device!.name;
    await expectLater(
      find.byKey(_key),
      matchesGoldenFile('$folder/$scenarioName/$testName$dot$deviceName.png'),
    );
  }
}

class GoldenTester extends GoldenTesterBase {
  GoldenTester({
    required Widget Function(Key key) widget,
    required Widget Function(Widget) wrapper,
    String testName = '',
  }) : super(testName: testName, widget: widget, wrapper: wrapper);

  Future<void> builder(
    WidgetTester tester,
    Device device, {
    required String scenarioName,
    required Future<void> Function(GoldenTesterBase) scenario,
  }) async {
    await setScenario(
        tester: tester, device: device, scenarioName: scenarioName);
    await scenario(this);
    await matchesGolden();
  }
}
