import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'location_setup_screen.dart';
import 'user_details_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.authResolved) {
          return const _AuthLoadingScreen();
        }
        if (!auth.isLoggedIn) {
          return const LoginScreen();
        }
        if (!auth.hasBasicDetails) {
          return const UserDetailsScreen();
        }
        if (!auth.hasLocationDetails) {
          return const LocationSetupScreen();
        }
        return const HomeScreen();
      },
    );
  }
}

class _AuthLoadingScreen extends StatelessWidget {
  const _AuthLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.cream, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: AppSpacing.md),
                Text(
                  'Checking your account...',
                  style: AppTextStyles.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
