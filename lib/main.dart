import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/boot_animation_screen.dart'; // WICHTIG: Diesen Import hinzufügen!

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
      // Einheitliches Dark-Theme für die gesamte App
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dein Deep Navy Black
      ),
      home: const BootAnimationScreen(),
    );
  }
}