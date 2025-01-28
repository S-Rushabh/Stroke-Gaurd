import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/onboarding_screen.dart';
import 'package:stroke_gaurd/authentication/login_screen.dart';
import 'package:stroke_gaurd/authentication/signup_screen.dart';
import 'package:stroke_gaurd/authentication/forgot_password_screen.dart';
import 'package:stroke_gaurd/screens/app/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stroke-Gaurd',
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/app': (context) => HomeScreen(userId: '',),
      },
    );
  }
}
