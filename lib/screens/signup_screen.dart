import 'package:flutter/material.dart';

import 'success_screen.dart';

// The signup page needs state because inputs and tips change.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for signup data.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  final _birthController = TextEditingController();
  DateTime? _birthDate;
  String? _creature;
  bool _submitting = false;
  bool _submissionStarted = false;

  Future<void> _pickBirthDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
    );
    if (!mounted || date == null) return;
    setState(() {
      _birthDate = date;
      _birthController.text = '${date.month}/${date.day}/${date.year}';
    });
  }

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

  // The synchronous guard also protects calls through a stale button callback.
  Future<void> _submitForm() async {
    if (_submissionStarted || !_formKey.currentState!.validate()) return;
    _submissionStarted = true;
    final name = _nameController.text.trim();
    final creature = _creature!;
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    // A popped route can remain mounted during its exit animation.
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SuccessScreen(userName: name, creatureType: creature),
      ),
    );
  }

  @override
  void dispose() {
    _birthController.dispose();
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
        title: const Text('Creature Registry'),
        centerTitle: true,
        backgroundColor: const Color(0xFF241336),
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
                    Icons.nightlight_round,
                    size: 54,
                    color: Colors.orangeAccent,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Register Your Creature',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'A place in the crypt awaits you.',
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

                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Creature Type',
                          ),
                          items:
                              const [
                                    'Ghost',
                                    'Bat',
                                    'Black Cat',
                                    'Pumpkin Spirit',
                                    'Witch',
                                  ]
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                          onChanged: _submitting
                              ? null
                              : (value) => setState(() => _creature = value),
                          validator: (value) =>
                              value == null ? 'Please select a creature' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _birthController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Birth Date',
                            prefixIcon: Icon(Icons.calendar_month),
                          ),
                          onTap: _submitting ? null : _pickBirthDate,
                          validator: (_) => _birthDate == null
                              ? 'Please select your birth date'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _submitting ? null : _submitForm,
                          icon: _submitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.person_add),
                          label: Text(
                            _submitting
                                ? 'Registering...'
                                : 'Register Creature',
                          ),
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
                      color: const Color(0xFF332345),
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
                      color: const Color(0xFF442532),
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
