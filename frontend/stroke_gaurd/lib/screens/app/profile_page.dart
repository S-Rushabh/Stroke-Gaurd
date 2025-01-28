import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  bool autoUpdate = true; // Default value for auto-update toggle
  String version = "1.0.0"; // Hardcoded version
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _animationController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'profile-picture',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFF006a94),
                        child: Text(
                          'J',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ms. Jane Moore',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006a94),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '📱 01234 456789',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      '📍 London, SW1 2JZ',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🗓 Date of Birth: 10/05/1987',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    Text(
                      '👤 Gender: Female',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Settings Section
              Text(
                'Settings',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF006a94),
                ),
              ),
              const SizedBox(height: 12),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_animationController),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Version info
                      ListTile(
                        leading: const Icon(Icons.info_outline, color: Color(0xFF006a94)),
                        title: Text(
                          'Version: $version',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[300]),

                      // About Us
                      ListTile(
                        leading: const Icon(Icons.info_outline, color: Color(0xFF006a94)),
                        title: const Text(
                          'About Us',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUsPage()),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),

                      // Theme & Interactions
                      ListTile(
                        leading: const Icon(Icons.palette, color: Color(0xFF006a94)),
                        title: const Text(
                          'Theme & Interactions',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThemeAndInteractionsPage(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: Colors.grey[300]),

                      // Auto Update toggle
                      ListTile(
                        leading: const Icon(Icons.update, color: Color(0xFF006a94)),
                        title: const Text(
                          'Auto Update',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Switch(
                          value: autoUpdate,
                          activeColor: const Color(0xFF006a94),
                          onChanged: (value) {
                            setState(() {
                              autoUpdate = value;
                            });
                          },
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[300]),

                      // Contact Us
                      ListTile(
                        leading: const Icon(Icons.mail_outline, color: Color(0xFF006a94)),
                        title: const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Contact Us"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text("Phone: 01234 567890"),
                                    Text("Email: support@example.com"),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF6F8FA),
    );
  }
}

// Placeholder for AboutUsPage
class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "About Us Page",
          style: TextStyle(fontSize: 18, color: Color(0xFF006a94)),
        ),
      ),
    );
  }
}

// Placeholder for ThemeAndInteractionsPage
class ThemeAndInteractionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Theme & Interactions Page",
          style: TextStyle(fontSize: 18, color: Color(0xFF006a94)),
        ),
      ),
    );
  }
}
