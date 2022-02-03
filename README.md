# Golden tools

The useful tools for golden tests and different devices.

## Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:golden/golden.dart';

void main() {
  setUpAll(() async {
    await init();
  });

  group('Login golden -', () {
    LoginGoldenTester loginTester;
    setUp(() {
      loginTester = LoginGoldenTester();
    });

    testDeviceGoldens(
      'loaded page',
      (tester, device) => loginTester.builder(tester, device, scenarioName: 'init', scenario: (_) async {
        await loginTester.init();
      }),
      devices: GoldenTestDevices.bundle,
    );

    testDeviceGoldens(
      'entered an email',
      (tester, device) => loginTester.builder(tester, device, scenarioName: 'init->email', scenario: (_) async {
        await loginTester.init();
        await loginTester.enterEmail('some@email.ru');
      }),
      devices: GoldenTestDevices.bundle,
    );
    testDeviceGoldens(
      'entered a wrong email and pushed a button',
      (tester, device) => loginTester.builder(tester, device, scenarioName: 'init->wrong_email->next_button', scenario: (_) async {
        await loginTester.init();
        await loginTester.enterEmail('some_email.ru');
        await loginTester.pushNextButton();
      }),
      devices: GoldenTestDevices.bundle,
    );

    testDeviceGoldens(
      'entered a correct email and pushed a button',
      (tester, device) => loginTester.builder(tester, device, scenarioName: 'init->correct_email->next_button', scenario: (_) async {
        await loginTester.init();
        await loginTester.enterEmail('some@email.ru');
        await loginTester.pushNextButton();
      }),
      devices: GoldenTestDevices.bundle,
    );

    testDeviceGoldens(
      'entered a password',
      (tester, device) => loginTester.builder(tester, device, scenarioName: 'init->correct_email->next_button->password', scenario: (_) async {
        await loginTester.init();
        await loginTester.enterEmail('some@email.ru');
        await loginTester.pushNextButton();
        await loginTester.enterPassword('password');
      }),
      devices: GoldenTestDevices.bundle,
    );

    testDeviceGoldens(
      'entered a password and pushed a button',
      (tester, device) =>
          loginTester.builder(tester, device, scenarioName: 'init->correct_email->next_button->password->next_button', scenario: (_) async {
        await loginTester.init();
        await loginTester.enterEmail('some@email.ru');
        await loginTester.pushNextButton();
        await loginTester.enterPassword('password');
        await loginTester.pushNextButton();
      }),
      devices: GoldenTestDevices.bundle,
    );
  });
}

class LoginGoldenTester extends GoldenTester {
  LoginGoldenTester()
      : super(
          widget: (key) => LoginPage(
            key: key,
            loginType: LoginType.email,
          ),
          wrapper: (child) => Helper.create(child: child),
        );

  Future<void> init() async {
    await tester.pumpAndSettle();
  }

  Future<void> enterEmail(String email) async {
    final finder = find.descendant(
      of: find.byType(LoginScreen),
      matching: find.byType(SpecialFormTextField),
    );
    expect(finder, findsOneWidget);
    await tester.enterText(finder, email);

    await tester.pump();
  }

  Future<void> pushNextButton() async {
    final finder = find.descendant(
      of: find.byType(LoginScreen),
      matching: find.byType(NextButton),
    );
    expect(finder, findsOneWidget);
    await tester.tap(finder);

    await tester.pumpAndSettle();
  }

  Future<void> enterPassword(String password) async {
    final finder = find.descendant(
      of: find.byType(LoginScreen),
      matching: find.byType(SpecialFormTextField),
    );
    expect(finder, findsOneWidget);
    await tester.enterText(finder, password);

    await tester.pump();
  }
}

```
