import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'The Haunted Creature Registry',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orange,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF180F26),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: const Color(0xFFE9DDF6),
        displayColor: const Color(0xFFE9DDF6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF30213F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(16),
      ),
    ),
    home: const WelcomeScreen(),
  );
}
