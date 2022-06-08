import 'package:flutter/material.dart';

class NamedTheme {
  const NamedTheme({
    required this.name,
    required this.data,
  });

  final String name;
  final ThemeData data;

  static final defaultTheme = NamedTheme(
    name: 'light',
    data: ThemeData.light(),
  );
}
