import 'package:flutter/material.dart';

enum BrightnessContrast {
  light(brightness: Brightness.light, hightContrast: false),
  lightContrast(brightness: Brightness.light, hightContrast: true),
  dark(brightness: Brightness.dark, hightContrast: false),
  darkContrast(brightness: Brightness.dark, hightContrast: true);

  const BrightnessContrast({
    required this.brightness,
    required this.hightContrast,
  });
  final Brightness brightness;
  final bool hightContrast;
}
