import 'dart:ui';

import 'package:flutter/widgets.dart';

class Device {
  const Device({
    required this.name,
    required this.size,
    this.devicePixelRatio = 1.0,
    this.textScale = 1.0,
    this.brightness = Brightness.light,
    this.highContrast = false,
    this.safeArea = const EdgeInsets.all(0),
  });

  /// [iPhone5S] matches specs of iphone5s the smallest device
  static const Device iPhone5S = Device(
    name: 'iPhone5S',
    size: Size(320, 568),
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  );

  /// [iphone11] matches specs of iphone11, but with lower DPI for performance
  static const Device iphone11 = Device(
    name: 'iphone11',
    size: Size(414, 896),
    devicePixelRatio: 1.0,
    safeArea: EdgeInsets.only(top: 44, bottom: 34),
  );

  /// [tabletLandscape] example of tablet that in landscape mode
  static const Device tabletLandscape =
      Device(name: 'tablet_landscape', size: Size(1366, 1024));

  /// [tabletPortrait] example of tablet that in portrait mode
  static const Device tabletPortrait =
      Device(name: 'tablet_portrait', size: Size(1024, 1366));

  final String name;
  final Size size;
  final double devicePixelRatio;
  final double textScale;
  final Brightness brightness;
  final bool highContrast;
  final EdgeInsets safeArea;

  Device copyWith({
    String? name,
    Size? size,
    double? devicePixelRatio,
    double? textScale,
    Brightness? brightness,
    bool? highContrast,
    EdgeInsets? safeArea,
  }) {
    return Device(
      name: name ?? this.name,
      size: size ?? this.size,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      textScale: textScale ?? this.textScale,
      brightness: brightness ?? this.brightness,
      highContrast: highContrast ?? this.highContrast,
      safeArea: safeArea ?? this.safeArea,
    );
  }

  /// [toTheme] convenience method to copy the current device and apply needed theme and contrast
  Device toTheme({String? name, Brightness? brightness, bool? highContrast}) {
    return copyWith(
        name: name, brightness: brightness, highContrast: highContrast);
  }

  @override
  String toString() {
    return 'Device: $name, ${size.width}x${size.height} br: $brightness, contrast: $highContrast, ratio: $devicePixelRatio, text: $textScale, safe: $safeArea';
  }
}
