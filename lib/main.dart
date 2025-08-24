import 'package:calculator/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // A light grey
        appBarTheme: const AppBarTheme(
          color: Color(0xFFF5F5F5), // Matching app bar
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        popupMenuTheme: const PopupMenuThemeData(color: Color(0xFFF5F5F5)),
      ),
      darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(color: Colors.black),
          popupMenuTheme:
              PopupMenuThemeData(elevation: 15, shadowColor: Colors.cyan)),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}