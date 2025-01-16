import 'package:flutter/material.dart';
import 'screens/getstarted.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stroke Guard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GetStartedScreen(),
    );
  }
}
