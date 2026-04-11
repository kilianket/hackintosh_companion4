import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // WICHTIG: Importiere deinen Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hackintosh Companion',
      theme: ThemeData(brightness: Brightness.dark),
      // HIER ÄNDERN:
      home: const BootAnimationScreen(),
    );
  }
}