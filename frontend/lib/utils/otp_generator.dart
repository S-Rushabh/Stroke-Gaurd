import 'dart:math';

class OTPGenerator {
  static String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }
}
