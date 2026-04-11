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
      title: 'Hackintosh Companion',
      debugShowCheckedModeBanner: false, // Entfernt das rote "Debug" Banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Hier sagen wir Flutter, dass es mit DEINEM HomeScreen starten soll
      home: const HomeScreen(),
    );
  }
}