import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/features/cart/provider/cart_provider.dart';
import 'package:freewheel_mart/features/shop/provider/product_provider.dart';
import 'package:freewheel_mart/features/wallet/provider/wallet_provider.dart';
import 'package:freewheel_mart/firebase_options.dart';
import 'package:freewheel_mart/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
