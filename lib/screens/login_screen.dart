import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../utils/route_transitions.dart';
import 'home_screen.dart';
import 'user_details_screen.dart';

enum _AuthMode { choose, login, signup }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final _loginIdentifierController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmPasswordController = TextEditingController();

  _AuthMode _mode = _AuthMode.choose;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _loginIdentifierController.dispose();
    _loginPasswordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().loginWithGoogle();
      await _openNextStep();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _formatError(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _login() async {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().loginWithEmailPassword(
        identifier: _loginIdentifierController.text.trim(),
        password: _loginPasswordController.text.trim(),
      );
      await _openNextStep();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _formatError(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signup() async {
    if (!(_signupFormKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().signupWithEmailPassword(
        name: _signupNameController.text.trim(),
        email: _signupEmailController.text.trim(),
        password: _signupPasswordController.text.trim(),
      );
      await _openNextStep();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = _formatError(e));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _formatError(Object error) {
    if (error is FirebaseAuthException) {
      return error.message ?? 'Unable to continue right now.';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  void _setMode(_AuthMode mode) {
    setState(() {
      _mode = mode;
      _error = null;
    });
  }

  Future<void> _openNextStep() async {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;

    Widget nextPage;
    if (!auth.hasBasicDetails) {
      nextPage = const UserDetailsScreen();
    } else {
      nextPage = const HomeScreen();
    }

    await Navigator.of(context).pushAndRemoveUntil(
      fadeRoute(page: nextPage),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.cream, AppColors.background, Color(0xFFFFE2C9)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: AppColors.ink,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Foodie Finder',
                                style: AppTextStyles.h2.copyWith(
                                  color: AppColors.cream,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Choose how you want to continue',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.creamDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (_mode == _AuthMode.choose) ...[
                          OutlinedButton.icon(
                            onPressed: _isLoading ? null : _continueWithGoogle,
                            icon: const Icon(Icons.g_mobiledata_rounded),
                            label: const Text('Continue with Google'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () => _setMode(_AuthMode.login),
                            icon: const Icon(Icons.email_rounded),
                            label: const Text('Continue with Email'),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () => _setMode(_AuthMode.signup),
                            icon: const Icon(Icons.person_add_alt_1_rounded),
                            label: const Text('Sign up'),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Google will show the accounts available on this phone.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ] else ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: _isLoading
                                  ? null
                                  : () => _setMode(_AuthMode.choose),
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Back'),
                            ),
                          ),
                          if (_mode == _AuthMode.login) ...[
                            Text('Login', style: AppTextStyles.h3),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Old users can log in with email or the saved name plus password.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Form(
                              key: _loginFormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _loginIdentifierController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email or name',
                                      prefixIcon: Icon(Icons.person_rounded),
                                    ),
                                    validator: (value) =>
                                        (value == null || value.trim().isEmpty)
                                        ? 'Enter email or name'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _loginPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock_rounded),
                                    ),
                                    validator: (value) {
                                      if ((value?.trim().length ?? 0) < 6) {
                                        return 'Enter at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _login,
                                    child: const Text('Login'),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            Text('Sign up', style: AppTextStyles.h3),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Create a new account with name, email, and password.',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Form(
                              key: _signupFormKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _signupNameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      prefixIcon: Icon(Icons.person_rounded),
                                    ),
                                    validator: (value) =>
                                        (value == null || value.trim().isEmpty)
                                        ? 'Enter your name'
                                        : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _signupEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.email_rounded),
                                    ),
                                    validator: (value) {
                                      final text = value?.trim() ?? '';
                                      if (text.isEmpty || !text.contains('@')) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _signupPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock_rounded),
                                    ),
                                    validator: (value) {
                                      if ((value?.trim().length ?? 0) < 6) {
                                        return 'Enter at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller:
                                        _signupConfirmPasswordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: 'Confirm password',
                                      prefixIcon: Icon(Icons.lock_rounded),
                                    ),
                                    validator: (value) {
                                      if (value?.trim() !=
                                          _signupPasswordController.text
                                              .trim()) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  ElevatedButton(
                                    onPressed: _isLoading ? null : _signup,
                                    child: const Text('Create account'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                        if (_error != null) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            _error!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.red.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        if (_isLoading) ...[
                          const SizedBox(height: AppSpacing.md),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
