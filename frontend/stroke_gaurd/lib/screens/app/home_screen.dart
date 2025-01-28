import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'help_page.dart';
import 'chat_page.dart';

class HomeScreen extends StatefulWidget {
  final String userId; // Pass the user's ID to fetch their data from Firestore

  const HomeScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? userName; // Holds the user's name fetched from Firestore
  bool isLoading = true; // Tracks loading state

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user's name when the screen initializes
  }

  // Fetch the user's name from Firestore
  Future<void> _fetchUserName() async {
    if (widget.userId.isEmpty) {
      setState(() {
        userName = 'User';
        isLoading = false;
      });
      print('Error: User ID is empty');
      return;
    }

    print('Fetching user data for ID: ${widget.userId}'); // Debug log

    try {
      final doc = await FirebaseFirestore.instance.collection('userdata').doc(widget.userId).get();
      if (doc.exists) {
        setState(() {
          userName = doc['name'] ?? 'User';
          isLoading = false;
        });
        print('User name fetched: $userName'); // Debug log
      } else {
        setState(() {
          userName = 'User';
          isLoading = false;
        });
        print('Document does not exist for userId: ${widget.userId}'); // Debug log
      }
    } catch (e) {
      print('Error fetching user name: $e');
      setState(() {
        userName = 'User';
        isLoading = false;
      });
    }
  }

  // List of pages for the NavigationBar
  List<Widget> get _pages => [
    HomePage(name: userName ?? 'User'), // Pass the user's name to the HomePage
    HelpPage(),
    ChatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006a94), // Primary color for the AppBar
        title: isLoading
            ? const CircularProgressIndicator(color: Colors.white) // Show loader while fetching name
            : Text(
          _currentIndex == 0
              ? 'Hello, ${userName ?? 'User'}' // Dynamically set the title for the Home page
              : _getAppBarTitle(), // Get other titles based on index
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: _currentIndex == 0 // Only show the logout button on the Home page
            ? [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white, // Set the icon color to white
            ),
            onPressed: () {
              // Handle logout and navigate to login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ]
            : null, // No actions for other pages
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading while fetching user data
          : _pages[_currentIndex], // Show the current page
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: const Color(0xFF006a94).withOpacity(0.2), // Subtle indicator
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Colors.grey),
            selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF006a94)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.help_rounded, color: Color(0xFF006a94)),
            label: 'Help',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.chat_bubble_rounded, color: Color(0xFF006a94)),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Colors.grey),
            selectedIcon: Icon(Icons.person, color: Color(0xFF006a94)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Get the title for other pages
  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 1:
        return 'Help';
      case 2:
        return 'Chat';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }
}
