// ==============================================================
// FILE: lib/main.dart - WORKING FOR WEB
// ==============================================================
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Firebase Web Configuration - GET FROM FIREBASE CONSOLE
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC2WRSrNT_amxU0SECjNsGtO2bUX-W7LjI",
        authDomain: "fitlife-9c9f3.firebaseapp.com",
        projectId: "fitlife-9c9f3",
        storageBucket: "fitlife-9c9f3.firebasestorage.app",
        messagingSenderId: "388102120008",
        appId: "1:388102120008:web:3aa8514ef164abe9baae7d",
      ),
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }
  
  runApp(const FitnessApp());
}

class FitnessApp extends StatelessWidget {
  const FitnessApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}