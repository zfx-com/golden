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
        key = UniqueKey();

  final String folder = 'golden';

  @protected
  final Key key;

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
    await tester.pumpWidget(_wrapper(_widget(key)));
  }

  Future<void> matchesGolden() async {
    final dot = testName.isEmpty ? '' : '.';
    final deviceName = device == null ? '' : device!.name;
    await expectLater(
      find.byWidgetPredicate((widget) => true).first,
      matchesGoldenFile('$folder/$scenarioName/$testName$dot$deviceName.png'),
    );
  }
}

typedef PumpingCallback = Future<void> Function(WidgetTester tester);

class GoldenTester extends GoldenTesterBase {
  GoldenTester({
    required Widget Function(Key key) widget,
    required Widget Function(Widget) wrapper,
    String testName = '',
    PumpingCallback? postPumping = _defaultPostPumping,
  })  : _postPumping = postPumping,
        super(testName: testName, widget: widget, wrapper: wrapper);

  final PumpingCallback? _postPumping;

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
    await _postPumping?.call(tester);
  }

  static Future<void> _defaultPostPumping(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));
  }
}
