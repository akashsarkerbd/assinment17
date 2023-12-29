import 'package:flutter/material.dart';
import 'package:google_map_assignment/ui/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Google Map",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

