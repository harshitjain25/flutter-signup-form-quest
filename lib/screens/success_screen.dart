import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    required this.userName,
    required this.creatureType,
  });
  final String userName;
  final String creatureType;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 1));
  bool get _valid =>
      widget.userName.trim().isNotEmpty &&
      widget.creatureType.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    // Defer navigation until the route has been installed. Only scheduled once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_valid) {
        _returnToFoyer();
      } else {
        _confetti.play();
      }
    });
  }

  void _returnToFoyer() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const WelcomeScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop) _returnToFoyer();
    },
    child: Scaffold(
      body: !_valid
          ? const SizedBox.shrink()
          : SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🎃', style: TextStyle(fontSize: 72)),
                          const SizedBox(height: 24),
                          Text(
                            'Welcome, ${widget.userName.trim()}!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Creature registered: ${widget.creatureType.trim()}.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          FilledButton(
                            onPressed: _returnToFoyer,
                            child: const Text('Back to the Foyer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ConfettiWidget(
                    confettiController: _confetti,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.orange,
                      Colors.deepPurple,
                      Colors.white,
                    ],
                  ),
                ],
              ),
            ),
    ),
  );
}
