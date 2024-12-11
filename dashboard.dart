import 'package:flutter/material.dart';
import 'package:test_one/Segregate.dart';
import 'package:test_one/list.dart';
import 'package:test_one/loginpage.dart';
import 'package:test_one/upload.dart'; // Import your PatientsListPage

class dashboard extends StatefulWidget {
  const dashboard({Key? key}) : super(key: key);

  @override
  State<dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<dashboard> {
  bool showSidebar = false;

  void toggleSidebar() {
    setState(() {
      showSidebar = !showSidebar;
    });
  }

  void closeSidebar() {
    setState(() {
      showSidebar = false;
    });
  }

  void handleLogoutPress() {
    Navigator.pushNamed(context, '/login');
  }

  void handleSegregatePress() {
    Navigator.pushNamed(context, '/segregation');
  }

  @override
  Widget build(BuildContext context) {
    final double windowWidth = MediaQuery.of(context).size.width;
    final double windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE6EEFF),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: windowWidth,
                padding: EdgeInsets.only(
                  top: windowHeight * 0.1,
                  bottom: windowHeight * 0.02,
                  left: 10,
                  right: 10,
                ),
                color: Color(0xFF3D6DCC),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        showSidebar ? Icons.close : Icons.menu,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: toggleSidebar,
                    ),
                    Text(
                      'Welcome, Doctor!',
                      style: TextStyle(
                        fontSize: windowWidth * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: windowWidth * 0.8,
                        margin: EdgeInsets.only(bottom: windowHeight * 0.03),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Upload()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: windowHeight * 0.025,
                            ),
                            backgroundColor: Color(0xFF3D6DCC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 20,
                          ),
                          child: Text(
                            'Upload MRI Images',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: windowWidth * 0.8,
                        margin: EdgeInsets.only(bottom: windowHeight * 0.03),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Segregate()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: windowHeight * 0.025,
                            ),
                            backgroundColor: Color(0xFF3D6DCC),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 20,
                          ),
                          child: Text(
                            'Predict using BMI and Volume',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showSidebar)
            GestureDetector(
              onTap: closeSidebar,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: windowWidth * 0.6,
                    padding: EdgeInsets.symmetric(
                      vertical: windowHeight * 0.1,
                      horizontal: windowWidth * 0.05,
                    ),
                    color: Color(0xFFE6EEFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 150),
                          child: IconButton(
                            onPressed: closeSidebar,
                            icon: Icon(Icons.close, size: 30, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: windowHeight * 0.02),
                        _buildSidebarItem(
                          icon: Icons.people,  // Multiuser icon for List of Patients
                          title: 'List of Patients',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => PatientList()), // Replace with your actual page
                            );
                          },
                        ),
                        _buildSidebarItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => loginpage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
