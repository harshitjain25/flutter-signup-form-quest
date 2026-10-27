
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';

void main() {
  testWidgets('Signup page displays required fields', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('Empty signup form shows validation errors', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);
  });
}
