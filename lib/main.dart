import 'package:flutter/material.dart';
import 'Auth_screens/splash_screen.dart';


void main() {
  try {
  runApp(const LocknoteApp());
}  catch (e) {
  debugPrint(e.toString());
}
}

class LocknoteApp extends StatelessWidget {
  const LocknoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locknote',
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}