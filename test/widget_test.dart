import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/screens/signup_screen.dart';
import 'package:signup_app/screens/success_screen.dart';
import 'package:signup_app/screens/welcome_screen.dart';

class RegistrationObserver extends NavigatorObserver {
  int replacements = 0;
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    replacements++;
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<void> openSignup(
  WidgetTester tester, {
  NavigatorObserver? observer,
}) async {
  await tester.pumpWidget(
    MaterialApp(navigatorObservers: [?observer], home: const WelcomeScreen()),
  );
  await tester.tap(find.text('Enter the Registry'));
  await tester.pumpAndSettle();
}

Future<void> submit(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Register Creature'));
  await tester.tap(find.text('Register Creature'));
  await tester.pump();
}

Future<void> fillValid(WidgetTester tester) async {
  await tester.enterText(field('Full Name'), '  Alex  ');
  await tester.enterText(field('Email Address'), 'alex@example.com');
  await tester.enterText(field('Password'), 'secret123');
  await tester.enterText(field('Confirm Password'), 'secret123');
  await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Ghost').last);
  await tester.pumpAndSettle();
  await tester.ensureVisible(field('Birth Date'));
  await tester.tap(field('Birth Date'));
  await tester.pumpAndSettle();
  final picker = tester.widget<DatePickerDialog>(find.byType(DatePickerDialog));
  expect(picker.lastDate.isAfter(DateUtils.dateOnly(DateTime.now())), isFalse);
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Welcome appears and Enter opens signup; Back returns to foyer', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byType(WelcomeScreen), findsOneWidget);
    await tester.tap(find.text('Enter the Registry'));
    await tester.pumpAndSettle();
    expect(find.byType(SignupScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('Empty fields, creature, and birth date are required', (
    tester,
  ) async {
    await openSignup(tester);
    await submit(tester);
    await tester.pumpAndSettle();
    for (final message in [
      'Please enter your name',
      'Please enter your email',
      'Please enter a password',
      'Please confirm your password',
      'Please select a creature',
      'Please select your birth date',
    ]) {
      expect(find.text(message), findsOneWidget);
    }
    expect(find.byType(SuccessScreen), findsNothing);
  });

  for (final entry in <String, List<String>>{
    'Invalid email': ['Email Address', 'invalid', 'Please enter a valid email'],
    'Short password': [
      'Password',
      '123',
      'Password must be at least 6 characters',
    ],
    'Mismatched confirmation': [
      'Confirm Password',
      'different',
      'Passwords do not match',
    ],
  }.entries) {
    testWidgets('${entry.key} is rejected', (tester) async {
      await openSignup(tester);
      await fillValid(tester);
      await tester.ensureVisible(field(entry.value[0]));
      await tester.enterText(field(entry.value[0]), entry.value[1]);
      await submit(tester);
      await tester.pumpAndSettle();
      expect(find.text(entry.value[2]), findsOneWidget);
      expect(find.byType(SuccessScreen), findsNothing);
    });
  }

  testWidgets('Password visibility toggles both password fields', (
    tester,
  ) async {
    await openSignup(tester);
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: field('Password'),
              matching: find.byType(TextField),
            ),
          )
          .obscureText,
      isTrue,
    );
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: field('Password'),
              matching: find.byType(TextField),
            ),
          )
          .obscureText,
      isFalse,
    );
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: field('Confirm Password'),
              matching: find.byType(TextField),
            ),
          )
          .obscureText,
      isFalse,
    );
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: field('Password'),
              matching: find.byType(TextField),
            ),
          )
          .obscureText,
      isTrue,
    );
  });

  testWidgets(
    'Valid registration loads, blocks duplicate callbacks, and replaces signup',
    (tester) async {
      final observer = RegistrationObserver();
      await openSignup(tester, observer: observer);
      await fillValid(tester);
      await tester.ensureVisible(find.text('Register Creature'));
      final callback = tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Register Creature'),
          )
          .onPressed!;
      callback();
      callback(); // Invoke the saved callback, bypassing the disabled UI.
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Registering...'),
            )
            .onPressed,
        isNull,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SuccessScreen), findsNothing);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      for (var frame = 0; frame < 12; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(observer.replacements, 1);
      expect(find.text('Welcome, Alex!'), findsOneWidget);
      expect(find.text('Creature registered: Ghost.'), findsOneWidget);
      expect(find.byType(SignupScreen), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(SignupScreen), findsNothing);
    },
  );

  testWidgets('Foyer button clears completed registration', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SuccessScreen(userName: 'Alex', creatureType: 'Bat'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Back to the Foyer'));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.byType(SuccessScreen), findsNothing);
  });

  for (final data in [
    ('', 'Ghost'),
    ('  ', 'Ghost'),
    ('Alex', ''),
    ('Alex', '  '),
  ]) {
    testWidgets('Invalid success data ${data.toString()} redirects safely', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SuccessScreen(userName: data.$1, creatureType: data.$2),
        ),
      );
      expect(find.textContaining('Creature registered:'), findsNothing);
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.byType(SuccessScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Leaving during loading never navigates or updates disposed state',
    (tester) async {
      final observer = RegistrationObserver();
      await openSignup(tester, observer: observer);
      await fillValid(tester);
      await submit(tester);
      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(observer.replacements, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Leaving just before completion cancels navigation during the pop animation',
    (tester) async {
      final observer = RegistrationObserver();
      await openSignup(tester, observer: observer);
      await fillValid(tester);
      await submit(tester);
      await tester.pump(const Duration(milliseconds: 1900));
      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(observer.replacements, 0);
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Compact layout scrolls with the keyboard visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    await openSignup(tester);
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    await tester.pump();
    await tester.ensureVisible(find.text('Register Creature'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Local coach still loads tips and recovers from demo errors', (
    tester,
  ) async {
    await openSignup(tester);
    await tester.ensureVisible(find.text('Test local error'));
    await tester.tap(find.text('Test local error'));
    await tester.pump();
    expect(find.text('Loading local tip...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    expect(find.text('Local demo error. Please try again.'), findsOneWidget);
    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    expect(find.text('Preset demo tip—not live AI'), findsOneWidget);
  });
}
