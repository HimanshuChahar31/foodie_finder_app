import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase/firebase_bootstrap.dart';
import 'utils/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/dish_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/booking_provider.dart';
import 'screens/auth_gate_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseBootstrap.initialize().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DishProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) {
            final provider = cart ?? CartProvider();
            provider.attachAuthProvider(auth);
            return provider;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, BookingProvider>(
          create: (_) => BookingProvider(),
          update: (_, auth, booking) {
            final provider = booking ?? BookingProvider();
            provider.attachAuthProvider(auth);
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Foodie Finder',
        theme: AppTheme.lightTheme,
        home: const AuthGateScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
