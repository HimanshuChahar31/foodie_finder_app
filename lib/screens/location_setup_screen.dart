import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../utils/network_check.dart';
import '../utils/route_transitions.dart';
import 'home_screen.dart';

class LocationSetupScreen extends StatefulWidget {
  const LocationSetupScreen({super.key});

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  final _manualLocationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loadingGps = false;

  @override
  void dispose() {
    _manualLocationController.dispose();
    super.dispose();
  }

  Future<void> _continueWithGpsType() async {
    setState(() => _loadingGps = true);
    final hasInternet = await hasInternetConnection();
    setState(() => _loadingGps = false);
    if (!mounted) return;

    final location = hasInternet ? 'GPS Enabled Location' : 'GPS unavailable, manual pending';
    await context.read<AuthProvider>().setLocationDetails(location: location);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(fadeRoute(page: const HomeScreen()));
  }

  Future<void> _continueWithManual() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await context.read<AuthProvider>().setLocationDetails(
      location: _manualLocationController.text.trim(),
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(fadeRoute(page: const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.cream, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Set your location', style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Choose GPS for quick setup or add your location manually.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: _loadingGps ? null : _continueWithGpsType,
                      icon: const Icon(Icons.gps_fixed_rounded),
                      label: Text(_loadingGps ? 'Checking...' : 'Use GPS'),
                    ),
                    const SizedBox(height: 16),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _manualLocationController,
                            decoration: const InputDecoration(
                              labelText: 'Manual Location',
                              prefixIcon: Icon(Icons.location_on_rounded),
                            ),
                            validator: (v) => (v == null || v.trim().isEmpty)
                                ? 'Enter location'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _continueWithManual,
                            child: const Text('Continue with Manual Location'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
