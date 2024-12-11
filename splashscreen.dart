import 'package:flutter/material.dart';
import 'package:test_one/loginpage.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    // Delay navigation to the next page
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginpage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Keep the background color as blue
      body: Center(
        child: Image.asset(
          'assets/logo.jpg', // Path to the image in assets folder
          width: 200, // You can adjust the width as per your requirement
          height: 200, // You can adjust the height as per your requirement
        ),
      ),
    );
  }
}
