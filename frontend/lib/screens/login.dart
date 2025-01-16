import 'package:flutter/material.dart';
import 'sign_in.dart'; // Ensure this file exists
import '../utils/mongodb_helper.dart';
import 'otp_verification.dart'; // Ensure this file exists for OTPVerificationScreen

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();

  LoginScreen({super.key});

  Future<void> verifyPhone(BuildContext context) async {
    final phone = phoneController.text.trim();
    final userExists = await MongoDBHelper.checkIfPhoneExists(phone);

    if (userExists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(phone: phone), // Ensure OTPVerificationScreen exists
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number not registered. Please sign up.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyPhone(context),
              child: const Text('Log In'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()), // Navigate to SignInScreen
                );
              },
              child: const Text('Don’t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
