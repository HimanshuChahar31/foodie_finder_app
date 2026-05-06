import 'package:flutter/material.dart';
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
  bool _permissionDenied = false;
  bool _isRequestingPermission = false;
  String? _statusMessage;

  @override
  void dispose() {
    _manualLocationController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isRequestingPermission = true;
      _statusMessage = null;
    });

    final hasInternet = await hasInternetConnection();
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    if (!hasInternet) {
      setState(() {
        _statusMessage =
            'No internet detected. Please enter your location manually.';
        _isRequestingPermission = false;
      });
      return;
    }

    final granted = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Location Permission', style: AppTextStyles.h4),
          content: const Text('Allow Foodie Finder to access your location?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Deny'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Allow'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (granted == true) {
      Navigator.of(
        context,
      ).pushReplacement(fadeRoute(page: const HomeScreen()));
    }

    setState(() {
      _permissionDenied = true;
      _statusMessage =
          'Permission denied. Enter your location manually to continue.';
      _isRequestingPermission = false;
    });
  }

  void _saveManualLocation() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(
        context,
      ).pushReplacement(fadeRoute(page: const HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Location Setup',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Set your location',
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Allow location permission or enter your location manually.',
                style: AppTextStyles.bodyLarge,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: _isRequestingPermission
                    ? null
                    : _requestLocationPermission,
                icon: const Icon(Icons.location_on),
                label: Text(
                  _isRequestingPermission
                      ? 'Checking...'
                      : 'Allow location permission',
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (_statusMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    _statusMessage!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: _permissionDenied
                          ? AppColors.error
                          : AppColors.warning,
                    ),
                  ),
                ),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Manual location', style: AppTextStyles.h4),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _manualLocationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Enter city or address',
                        prefixIcon: Icon(Icons.map),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: _saveManualLocation,
                      child: const Text('Save location'),
                    ),
                  ],
                ),
              ),
              if (_permissionDenied)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: Text(
                    'Location permission was denied. Manual entry is available below.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
