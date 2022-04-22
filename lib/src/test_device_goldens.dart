import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';

const List<Locale> defaultLocales = <Locale>[
  Locale('us', 'US'),
];
const List<Device> defaultDevices = <Device>[Device.phone];

@isTestGroup
void testDeviceGoldens(
  String description,
  Future<void> Function(WidgetTester, Device, Locale) builder, {
  FutureOr<void> Function()? setUp,
  FutureOr<void> Function()? tearDown,
  List<Device> devices = defaultDevices,
  List<Locale> locales = defaultLocales,
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
    tearDown: tearDown,
    devices: devices,
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
    locales: locales,
  );
}

class _TestDeviceGoldens {
  static void testWidgetDevices(
    String description,
    Future<void> Function(WidgetTester, Device, Locale) builder, {
    FutureOr<void> Function()? setUp,
    FutureOr<void> Function()? tearDown,
    List<Device> devices = defaultDevices,
    List<Locale> locales = defaultLocales,
    bool? skip,
    Timeout? timeout,
    bool semanticsEnabled = true,
    TestVariant<Object?> variant = const DefaultTestVariant(),
    Iterable<String>? tags,
  }) {
    for (final device in devices) {
      for (final locale in locales) {
        testWidgets(
          '$description (${device.name}:$locale)',
          (tester) async {
            await setUp?.call();
            await _setSurfaceSize(tester, device);
            await builder(tester, device, locale);
            await tearDown?.call();
          },
          skip: skip,
          timeout: timeout,
          semanticsEnabled: semanticsEnabled,
          variant: variant,
          tags: [goldenTag, ...(tags ?? <String>[])],
        );
      }
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
}
