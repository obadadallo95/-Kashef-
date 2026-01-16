import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    // Use a Timer to navigate to home after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Use GoRouter to replace the current route
        context.go('/'); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF2E5BFF), // Lighter Royal Blue in center
              Color(0xFF0D2E8C), // Deep Navy Blue at edges
            ],
            stops: [0.1, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Center Logo
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width * 0.6,
                ),
                child: Image.asset(
                  'assets/images/SplashScreen.png', // User requested image
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Footer
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  Text(
                    "Powered by Kashef AI",
                    style: GoogleFonts.cairo(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
