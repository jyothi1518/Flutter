import 'package:flutter/material.dart';
import 'package:test_one/signup.dart';
import 'package:test_one/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_one/urls.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginpage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String loginApiUrl = '${Urls.url}/project.php';

  void handleLogin() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    final response = await http.post(
      Uri.parse(loginApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dashboard()),
      );
    } else {
      _showErrorDialog(data['message']);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;
    final double windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE6EEFF),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Color(0xFF3D6DCC),
              height: windowHeight * 0.2,
              width: windowWidth,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: windowWidth * 0.05, top: windowHeight * 0.05),
                    child: Image.asset(
                      'assets/logo.jpg',
                      width: windowWidth * 0.15,
                      height: windowWidth * 0.15,
                    ),
                  ),
                  SizedBox(width: windowWidth * 0.15), // Space between logo and text
                  Text(
                    'Doctor Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: windowWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      height: 9, // Adjust the height here, e.g., 1.5 for 50% more space
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: windowHeight * 0.05, horizontal: windowWidth * 0.1),
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    cursorColor: Colors.black, // Cursor color set to black
                    decoration: InputDecoration(
                      hintText: 'Doctor ID',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: windowWidth * 0.04), // Reduced text size
                  ),
                  SizedBox(height: windowHeight * 0.02), // Reduced the gap
                  TextField(
                    controller: _passwordController,
                    cursorColor: Colors.black, // Cursor color set to black
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: windowWidth * 0.04), // Reduced text size
                  ),
                  SizedBox(height: windowHeight * 0.05), // Reduced the gap
                  ElevatedButton(
                    onPressed: handleLogin,
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white), // Login text color set to black
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3D6DCC),
                      padding: EdgeInsets.symmetric(
                          horizontal: windowWidth * 0.12, // Reduced button width
                          vertical: windowHeight * 0.015 // Reduced button height
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  SizedBox(height: windowHeight * 0.04), // Reduced gap after login button
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => signup()),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.black, // Sign Up text color set to black
                        fontWeight: FontWeight.bold, // Bold Sign Up text
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
