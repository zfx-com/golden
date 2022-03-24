import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';

@isTestGroup
void testDeviceGoldens(
  String description,
  Future<void> Function(WidgetTester, Device) builder, {
  FutureOr<void> Function()? setUp,
  List<Device> devices = const [Device.phone],
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  Iterable<String>? tags,
}) {
  _TestDeviceGoldens.testWidgetDevices(
    description,
    builder,
    setUp: setUp,
    devices: devices,
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

class _TestDeviceGoldens {
  static void testWidgetDevices(
    String description,
    Future<void> Function(WidgetTester, Device) builder, {
    FutureOr<void> Function()? setUp,
    List<Device> devices = const [Device.phone],
    bool? skip,
    Timeout? timeout,
    bool semanticsEnabled = true,
    TestVariant<Object?> variant = const DefaultTestVariant(),
    Iterable<String>? tags,
  }) {
    for (final device in devices) {
      testWidgets(
        '$description (${device.name})',
        (tester) async {
          await setUp?.call();
          await _setSurfaceSize(tester, device);
          await builder(tester, device);
        },
        skip: skip,
        timeout: timeout,
        semanticsEnabled: semanticsEnabled,
        variant: variant,
        tags: _addGoldenTag(tags),
      );
    }
  }

  static Future<void> _setSurfaceSize(
      WidgetTester tester, Device device) async {
    await tester.binding.setSurfaceSize(device.size);
    tester.binding.window.physicalSizeTestValue = device.size;
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    tester.binding.window.textScaleFactorTestValue = device.textScale;
  }

  static const String goldenTag = 'golden';

  static Iterable<String> _addGoldenTag(Iterable<String>? inputTags) {
    if (inputTags != null) {
      return [goldenTag, ...inputTags];
    }
    return [goldenTag];
  }
}
