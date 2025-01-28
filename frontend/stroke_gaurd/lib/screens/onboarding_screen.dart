import 'package:flutter/material.dart';
import 'package:stroke_gaurd/authentication/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isLicenseAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for onboarding pages
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              buildPage(
                context,
                image: 'assets/images/onboarding/onboarding_img_1.png',
                title: 'Understand the Risk',
                description:
                'Stroke is a medical emergency. Early detection can save lives and reduce complications. Let’s make detection easier and faster.',
                backgroundColor: Colors.lightBlue[50],
              ),
              buildPage(
                context,
                image: 'assets/images/onboarding/onboarding_img_1.png',
                title: 'AI-Powered Detection',
                description:
                'Our advanced AI analyzes symptoms like facial droop, speech slurring, and arm weakness to detect potential strokes in real-time.',
                backgroundColor: Colors.lightBlue[50],
              ),
              buildPage(
                context,
                image: 'assets/images/onboarding/onboarding_img_1.png',
                title: 'Act Swiftly',
                description:
                'Get instant results and recommendations to seek medical attention immediately. Together, we can save lives.',
                backgroundColor: Colors.lightBlue[50],
              ),
              buildLicensePage(), // License and Agreement screen
            ],
          ),

          // Skip Button
          if (_currentIndex < 3)
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),

          // Bottom Navigation
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page Indicator Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 10,
                      width: _currentIndex == index ? 20 : 10,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? const Color(0xFF006a94)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),

                // Next/Get Started Button
                ElevatedButton.icon(
                  onPressed: (_currentIndex < 3 || _isLicenseAccepted)
                      ? () {
                    if (_currentIndex < 3) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006a94),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: _currentIndex < 3
                      ? const Icon(Icons.arrow_forward, color: Colors.white)
                      : const SizedBox(),
                  label: Text(
                    _currentIndex < 3
                        ? 'Next'
                        : _isLicenseAccepted
                        ? 'Get Started'
                        : 'Accept License',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build a generic onboarding page
  Widget buildPage(BuildContext context,
      {required String image,
        required String title,
        required String description,
        required Color? backgroundColor}) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the License and Agreement page
  Widget buildLicensePage() {
    return Container(
      color: Colors.lightBlue[50],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Adjusted License Icon Position
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.assignment,
              size: 60,
              color: Color(0xFF006a94),
            ),
          ),
          const SizedBox(height: 30),

          // Title
          const Text(
            'License and Agreement',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006a94),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Terms and Conditions Text
          Expanded(
            child: SingleChildScrollView(
              child: const Text(
                "Before proceeding, please take a moment to review our Terms and Conditions. "
                    "By logging in and using this application, you acknowledge that you have read, understood, "
                    "and agree to be bound by these terms.\n\n"
                    "Stroke Guard is designed to provide health-related insights and detect potential minor brain stroke symptoms, "
                    "but it is not a substitute for professional medical advice, diagnosis, or treatment. "
                    "We prioritize your privacy and data security; however, we cannot guarantee absolute protection. "
                    "Please remember that any decisions made based on the app’s insights are your responsibility.\n\n"
                    "For more details, please refer to our full Terms and Conditions. "
                    "If you do not agree with these terms, you may not use the application.",
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Checkbox and Button Layout Improvement
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _isLicenseAccepted,
                activeColor: const Color(0xFF006a94),
                onChanged: (value) {
                  setState(() {
                    _isLicenseAccepted = value ?? false;
                  });
                },
              ),
              const Flexible(
                child: Text(
                  'I accept the terms and conditions',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
