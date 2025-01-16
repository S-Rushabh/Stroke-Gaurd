import 'package:flutter/material.dart';
import 'home.dart';
import '../utils/mongodb_helper.dart';
import '../utils/otp_generator.dart'; // Adjust the path as per your project structure


class OTPVerificationScreen extends StatefulWidget {
  final String phone;

  const OTPVerificationScreen({super.key, required this.phone});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  String? generatedOTP; // To store the OTP for display

  @override
  void initState() {
    super.initState();
    fetchAndDisplayOTP();
  }

  Future<void> fetchAndDisplayOTP() async {
    // Call registerUser and get the generated OTP
    final otp = OTPGenerator.generateOTP();
    final isRegistered = await MongoDBHelper.registerUser("User", widget.phone);

    if (isRegistered) {
      setState(() {
        generatedOTP = otp; // Display the OTP on the UI
      });
    }
  }

  Future<void> verifyOTP(BuildContext context) async {
    final enteredOTP = otpController.text.trim();

    final isValid = await MongoDBHelper.verifyOTP(widget.phone, enteredOTP);
    if (isValid) {
      final name = await MongoDBHelper.getUserName(widget.phone);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(name: name),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (generatedOTP != null) // Display OTP when it's generated
              Text(
                'Your OTP is: $generatedOTP',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => verifyOTP(context),
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}