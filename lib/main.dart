import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Main application and theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Circle Signup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFF9F6FF),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
      home: const SignupPage(),
    );
  }
}

// The signup page needs state because inputs and tips change.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for signup data.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;

  // Task A: Only fixed, local demo data is used.
  static const String _tipCategory = 'password_help';

  static const Map<String, List<String>> _presetTips = {
    'password_help': [
      'Use a long password that is difficult to guess.',
      'Avoid reusing the same password across accounts.',
      'Use a unique password for every important account.',
    ],
  };

  bool _isLoadingTip = false;
  String? _currentTip;
  String? _tipError;

  // These options demonstrate local failure cases.
  bool _failNextTip = false;
  bool _emptyNextTip = false;

  int _tipIndex = 0;

  // Task A: Local lookup with simulated loading.
  Future<void> _getSignupTip() async {
    if (_isLoadingTip) return;

    setState(() {
      _isLoadingTip = true;
      _currentTip = null;
      _tipError = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Intentional failure for testing the error state.
    if (_failNextTip) {
      setState(() {
        _isLoadingTip = false;
        _failNextTip = false;
        _tipError = 'Local demo error. Please try again.';
      });
      return;
    }

    // Intentional empty-data test.
    if (_emptyNextTip) {
      setState(() {
        _isLoadingTip = false;
        _emptyNextTip = false;
        _tipError = 'No preset tips are available. Please retry.';
      });
      return;
    }

    final tips = _presetTips[_tipCategory];

    if (tips == null || tips.isEmpty) {
      setState(() {
        _isLoadingTip = false;
        _tipError = 'No preset tips found for this category.';
      });
      return;
    }

    final selectedTip = tips[_tipIndex % tips.length];

    if (selectedTip.length > 240) {
      setState(() {
        _isLoadingTip = false;
        _tipError = 'The preset tip is too long.';
      });
      return;
    }

    setState(() {
      _currentTip = selectedTip;
      _tipIndex++;
      _isLoadingTip = false;
    });
  }

  // These buttons make the error cases repeatable.
  void _testLocalError() {
    if (_isLoadingTip) return;
    _failNextTip = true;
    _emptyNextTip = false;
    _getSignupTip();
  }

  void _testMissingTip() {
    if (_isLoadingTip) return;
    _emptyNextTip = true;
    _failNextTip = false;
    _getSignupTip();
  }

  // Task C: Validate and display the entered name.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome, $name! Demo signup completed successfully.'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Circle'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  const Icon(
                    Icons.groups_rounded,
                    size: 54,
                    color: Colors.deepPurple,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Create Your Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Join our community and get started!',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  // Main form.
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }

                            final email = value.trim();
                            final emailPattern = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );

                            if (!emailPattern.hasMatch(email)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Task C: Confirm password.
                        TextFormField(
                          controller: _confirmController,
                          obscureText: !_showPassword,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.verified_user),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 24),

                        FilledButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.person_add),
                          label: const Text('Sign Up'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.all(17),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Task A: Signup Coach.
                  const Text(
                    'Local Signup Coach',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Get a helpful signup tip from our preset demo collection.',
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: _isLoadingTip ? null : _getSignupTip,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: const Text('Get a signup tip'),
                  ),

                  const SizedBox(height: 14),

                  if (_isLoadingTip)
                    const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Loading local tip...'),
                        ],
                      ),
                    ),

                  if (_currentTip != null)
                    Card(
                      color: const Color(0xFFEEE6FF),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Preset demo tip—not live AI',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(_currentTip!),
                          ],
                        ),
                      ),
                    ),

                  if (_tipError != null)
                    Card(
                      color: const Color(0xFFFFEAEA),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tipError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            TextButton.icon(
                              onPressed: _getSignupTip,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  const Text(
                    'Demo testing options',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: _isLoadingTip ? null : _testLocalError,
                        child: const Text('Test local error'),
                      ),
                      OutlinedButton(
                        onPressed: _isLoadingTip ? null : _testMissingTip,
                        child: const Text('Test missing tips'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'All tips are stored locally. No signup details '
                    'are used by this feature. No live AI or network '
                    'service is connected.',
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
