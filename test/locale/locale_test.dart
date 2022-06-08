import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden/golden.dart';

const locales = <Locale>[
  Locale('en'),
  Locale('en', 'US'),
  Locale('id', 'ID'),
  Locale('vi'),
  Locale('ms'),
  Locale('th'),
];

void main() {
  setUpAll(() async {});

  /// flutter test --update-goldens test/golden_test.dart
  group(
    'Example golden -',
    () {
      ExampleGoldenTester exampleTester = ExampleGoldenTester();
      CrashGoldenTester crashGoldenTester = CrashGoldenTester();

      setUp(() {
        exampleTester = ExampleGoldenTester();
        crashGoldenTester = CrashGoldenTester();
      });

      testDeviceGoldens(
        'loaded page',
        (tester, device, locale, theme) async {
          return exampleTester.builder(
            tester,
            device,
            locale,
            theme,
            scenarioName: 'init',
            scenario: (_) async {
              await exampleTester.init();
            },
          );
        },
        devices: [
          Device.iphone11,
        ],
        locales: locales,
      );

      testDeviceGoldens(
        'crash',
        (tester, device, locale, theme) async {
          return crashGoldenTester.builder(
            tester,
            device,
            locale,
            theme,
            scenarioName: 'crash',
            scenario: (_) async {
              await crashGoldenTester.init();
            },
          );
        },
        devices: [
          Device.iphone11,
        ],
        locales: [
          const Locale('en'),
        ],
      );
    },
  );
}

class ExampleGoldenTester extends GoldenTester {
  ExampleGoldenTester()
      : super(
          widget: (key) => const ExampleWidget(),
          wrapper: (child, locale, brightness) => MaterialApp(
            supportedLocales: locales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            locale: locale,
            home: Scaffold(body: child),
          ),
        );

  Future<void> init() async {
    await tester.pumpAndSettle();
  }
}

class CrashGoldenTester extends GoldenTester {
  CrashGoldenTester()
      : super(
          widget: (key) => const CrashWidget(),
          wrapper: (child, locale, brightness) => MaterialApp(
            supportedLocales: locales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            locale: locale,
            home: Scaffold(body: child),
          ),
        );

  Future<void> init() async {
    await tester.pumpAndSettle();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Test'));
  }
}

class CrashWidget extends StatelessWidget {
  const CrashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: const [
          Text(
              'Test crash sdkfhksd sdkfhjsd lkjflsdkj sdfljlksdf slkdfjlksdj sdfjlskdjf sdkfjlksdf sdlkfjsdlkf sdklfjlksdjf slkdjfklskdfj lksdjflksdjf'),
        ],
      ),
    );
  }
}
