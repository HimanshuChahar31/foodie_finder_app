import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';

enum _AuthMode { choose, login, signup }
enum _SignupMethod { email, phone }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _nameController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  _AuthMode _mode = _AuthMode.choose;
  _SignupMethod _signupMethod = _SignupMethod.email;
  String _selectedGender = 'Male';
  bool _isLoading = false;
  bool _otpRequested = false;
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _signupPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final auth = context.read<AuthProvider>();
    try {
      if (_mode == _AuthMode.login) {
        final username = _usernameController.text.trim();
        final email = username.contains('@') ? username : '$username@foodiefinder.app';
        await auth.loginWithEmailPassword(email: email, password: _passwordController.text);
      } else {
        if (_signupMethod == _SignupMethod.email) {
          await auth.loginWithEmailPassword(
            email: _emailController.text.trim(),
            password: _signupPasswordController.text,
          );
          await auth.setSignupProfile(
            name: _nameController.text.trim(),
            gender: _selectedGender,
          );
        } else {
          if (!_otpRequested) {
            await auth.sendPhoneOtp(_phoneController.text.trim());
            setState(() => _otpRequested = true);
            return;
          }
          await auth.verifyPhoneOtp(
            phoneNumber: _phoneController.text.trim(),
            smsCode: _otpController.text.trim(),
          );
          await auth.setSignupProfile(
            name: _nameController.text.trim(),
            gender: _selectedGender,
          );
        }
      }

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Foodie Finder',
                          style: AppTextStyles.h2.copyWith(color: AppColors.cream),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Login or signup to continue',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.creamDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                if (_mode == _AuthMode.choose) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: () => setState(() => _mode = _AuthMode.login), child: const Text('Login')),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: () => setState(() => _mode = _AuthMode.signup), child: const Text('Signup')),
                ] else ...[
                  TextButton(
                    onPressed: () => setState(() {
                      _mode = _AuthMode.choose;
                      _otpRequested = false;
                      _error = null;
                    }),
                    child: const Text('Back'),
                  ),
                  if (_mode == _AuthMode.login) ...[
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter username' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars password' : null,
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGender,
                      decoration: const InputDecoration(labelText: 'Gender'),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _selectedGender = v ?? 'Male'),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<_SignupMethod>(
                            value: _SignupMethod.email,
                            groupValue: _signupMethod,
                            title: const Text('Email'),
                            onChanged: (v) => setState(() {
                              _signupMethod = v!;
                              _otpRequested = false;
                            }),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<_SignupMethod>(
                            value: _SignupMethod.phone,
                            groupValue: _signupMethod,
                            title: const Text('Phone'),
                            onChanged: (v) => setState(() {
                              _signupMethod = v!;
                              _otpRequested = false;
                            }),
                          ),
                        ),
                      ],
                    ),
                    if (_signupMethod == _SignupMethod.email) ...[
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _signupPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars password' : null,
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Phone Number'),
                        validator: (v) => (v == null || v.trim().length < 10) ? 'Enter valid phone number' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _signupPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (v) => (v == null || v.length < 6) ? 'Min 6 chars password' : null,
                      ),
                      if (_otpRequested) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'OTP'),
                          validator: (v) => (!_otpRequested || (v != null && v.trim().length >= 6)) ? null : 'Enter valid OTP',
                        ),
                      ],
                    ],
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: Text(
                      _mode == _AuthMode.login
                          ? 'Login'
                          : (_signupMethod == _SignupMethod.phone && !_otpRequested)
                              ? 'Send OTP'
                              : 'Continue',
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
