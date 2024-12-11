import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_one/loginpage.dart';
import 'package:test_one/urls.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _SignupState();
}

class _SignupState extends State<signup> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void handleBack() {
    Navigator.of(context).pop();
  }

  Future<void> handleSignup() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _doctorNameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _departmentController.text.isEmpty ||
        _contactNumberController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please provide all the information.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    final Map<String, String> formData = {
      'username': _usernameController.text,
      'doctorName': _doctorNameController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'department': _departmentController.text,
      'contactNumber': _contactNumberController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('${Urls.url}/sign.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(responseData['message']),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Registration successful'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => loginpage()),
                      );
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Server error. Please try again later.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to register. Please check your connection.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;
    final double windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => loginpage()),
            );
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF3D6DCC),
        title: Align(
          alignment: Alignment.centerLeft,  // Align to the left
          child: Padding(
            padding: EdgeInsets.only(left: windowWidth * 0.1),  // Adjust the left padding
            child: Text(
              'Signup',
              style: TextStyle(
                fontSize: windowWidth * 0.06,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        toolbarHeight: 100,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: windowWidth,
                padding: EdgeInsets.only(left: 10, right: 10),
                color: Color(0xFF3D6DCC),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: windowHeight * 0.05),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.1),
                        child: Column(
                          children: [
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(labelText: 'Doctor ID'),
                            ),
                            TextField(
                              controller: _doctorNameController,
                              decoration: InputDecoration(labelText: 'Doctor Name'),
                            ),
                            TextField(
                              controller: _ageController,
                              decoration: InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: _genderController,
                              decoration: InputDecoration(labelText: 'Gender'),
                            ),
                            TextField(
                              controller: _departmentController,
                              decoration: InputDecoration(labelText: 'Department'),
                            ),
                            TextField(
                              controller: _contactNumberController,
                              decoration: InputDecoration(labelText: 'Contact Number'),
                              keyboardType: TextInputType.phone,
                            ),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(labelText: 'Password'),
                              obscureText: true,
                            ),
                            SizedBox(height: windowHeight * 0.05),
                            ElevatedButton(
                              onPressed: handleSignup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3D6DCC),
                                minimumSize: Size(windowWidth * 0.4, windowHeight * 0.05),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 20,
                              ),
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: windowWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
