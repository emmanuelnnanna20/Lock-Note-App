import 'package:flutter/material.dart';
import 'create_account_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to create account screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateAccountScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
        ),
        child:  Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Logo (using an icon for now - you can replace with actual logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:  Center(
                  child: Text(
                    '*',
                    style: GoogleFonts.urbanist(
                      fontSize: 60,
                      fontWeight: FontWeight.w800,
                      color: Colors.cyanAccent,
                    ),
                  )
                ),

              ),

              SizedBox(height: 10,),
              Text(
                'Lock-Note',
                style: GoogleFonts.urbanist(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}