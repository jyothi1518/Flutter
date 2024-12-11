import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_one/urls.dart';
import 'dashboard.dart'; // Import your Dashboard widget here
import 'admin_dashboard.dart'; // Import the Admin Dashboard widget for download functionality

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  bool loading = true;
  String error = '';
  String searchQuery = '';
  List<dynamic> allPatients = [];
  List<dynamic> filteredPatients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients(); // Fetch patients when the widget initializes
  }

  Future<void> fetchPatients() async {
    final String patientListApiUrl = '${Urls.url}/patientlist.php'; // Define the API URL

    try {
      final response = await http.get(Uri.parse(patientListApiUrl)); // Use the API URL here
      if (response.statusCode == 200) {
        setState(() {
          allPatients = json.decode(response.body); // Decode JSON response
          filteredPatients = allPatients; // Initialize filteredPatients with allPatients
          loading = false; // Set loading to false
        });
      } else {
        setState(() {
          error = 'Failed to load patients';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error fetching patients: $e';
        loading = false;
      });
    }
  }

  void updateFilteredPatients() {
    setState(() {
      filteredPatients = allPatients
          .where((patient) =>
      patient['patient_id'].toString().contains(searchQuery.toLowerCase()) || // Ensure toString for matching
          patient['prediction'].toLowerCase().contains(searchQuery.toLowerCase())) // Match against prediction
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE6EEFF),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: const Color(0xFF3D6DCC),
                padding: EdgeInsets.only(
                  top: screenHeight * 0.05,
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.05,
                ),
                height: screenHeight * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => dashboard()), // Navigate to your Dashboard
                            );
                          },
                          icon: Icon(Icons.arrow_back, size: screenHeight * 0.035, color: Colors.white),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'List of Patients',
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Welcome()), // Navigate to the Admin Dashboard
                        );
                      },
                      icon: Icon(Icons.download, size: screenHeight * 0.035, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: screenHeight * 0.025, color: Colors.grey.shade600),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search by Patient ID or Prediction',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          searchQuery = text;
                          updateFilteredPatients();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator(color: Colors.white))
                    : error.isNotEmpty
                    ? Center(child: Text(error, style: TextStyle(color: Colors.red, fontSize: screenHeight * 0.022)))
                    : filteredPatients.isNotEmpty
                    ? SingleChildScrollView(
                  child: Column(
                    children: filteredPatients.map((patient) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // Add vertical spacing between containers
                        padding: EdgeInsets.all(screenHeight * 0.02), // Padding for the container
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text('Patient ID: ${patient['patient_id']}'), // Display patient_id
                          subtitle: Text('Prediction: ${patient['prediction']}'), // Display prediction
                        ),
                      );
                    }).toList(),
                  ),
                )
                    : Center(child: Text('No patients found', style: TextStyle(color: Colors.red, fontSize: screenHeight * 0.022))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
