import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:convert';

import 'package:test_one/dashboard.dart';
import 'package:test_one/urls.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _className;
  double? _confidenceScore;
  String? _patientId;
  bool _showSaveButton = false;

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Upload image to Flask server for prediction
  Future<void> _uploadAndPredict(File image) async {
    if (_patientId == null || _patientId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid patient ID')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final uri = Uri.parse('${Urls.flaskurl}/predict');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = json.decode(String.fromCharCodes(responseData));

      setState(() {
        _className = result['class_name'];
        _confidenceScore = result['confidence_score'];
        _showSaveButton = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prediction: $_className with confidence ${((_confidenceScore ?? 0) * 100).toStringAsFixed(2)}%')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error predicting image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  // Save image details to XAMPP server database
  Future<void> _saveToDatabase() async {
    if (_image == null || _patientId == null || _className == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Missing data for saving')),
      );
      return;
    }

    try {
      var saveRequest = http.MultipartRequest(
        'POST',
        Uri.parse('${Urls.url}/uploadimage.php'),
      );
      saveRequest.fields['patient_id'] = _patientId!;
      saveRequest.fields['class_name'] = _className!;
      saveRequest.fields['confidence_score'] = _confidenceScore.toString();
      saveRequest.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          filename: path.basename(_image!.path),
        ),
      );

      var response = await saveRequest.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details saved successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save details: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Image',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF3D6DCC),
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => dashboard()),
            );
          },
        ),
      ),
      body: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Patient ID',
              ),
              onChanged: (value) {
                _patientId = value;
              },
            ),
            SizedBox(height: 10),
            if (_image != null)
              Image.file(_image!, height: 250, fit: BoxFit.cover)
            else
              Container(
                height: 250,
                color: Colors.grey[200],
                child: Center(child: Text('No image selected')),
              ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImageFromGallery,
              icon: Icon(Icons.photo_library),
              label: Text('Pick Image from Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D6DCC),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImageFromCamera,
              icon: Icon(Icons.camera_alt),
              label: Text('Capture Image from Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D6DCC),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            if (_image != null && !_isUploading)
              ElevatedButton(
                onPressed: () {
                  _uploadAndPredict(_image!);
                },
                child: Text('Predict'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D6DCC),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  foregroundColor: Colors.white,
                ),
              )
            else if (_isUploading)
              Center(child: CircularProgressIndicator()),
            SizedBox(height: 20),
            if (_className != null)
              Text('Prediction: $_className, Confidence: ${((_confidenceScore ?? 0) * 100).toStringAsFixed(2)}%'),
            if (_showSaveButton)
              ElevatedButton(
                onPressed: _saveToDatabase,
                child: Text('Save to Database'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D6DCC),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
