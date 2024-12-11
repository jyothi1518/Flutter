import 'package:flutter/material.dart';
import 'package:test_one/dashboard.dart';

class Segregate extends StatefulWidget {
  const Segregate({super.key});

  @override
  State<Segregate> createState() => _SegregateState();
}

class _SegregateState extends State<Segregate> {
  String selectedGender = 'male';
  String age = '';
  String height = '';
  String weight = '';
  String volume = '';
  String? bmi;
  String condition = '';

  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController volumeController = TextEditingController();

  void dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void calculateBmi() {
    if (height.isNotEmpty && weight.isNotEmpty) {
      final heightInMeters = double.parse(height) / 100;
      final weightInKg = double.parse(weight);
      final bmiValue = weightInKg / (heightInMeters * heightInMeters);
      setState(() {
        bmi = bmiValue.toStringAsFixed(2);
      });
    } else {
      setState(() {
        bmi = null;
      });
    }
  }

  void evaluateCondition() {
    if (volume.isNotEmpty) {
      final volumeValue = double.parse(volume);
      setState(() {
        condition = volumeValue < 1 ? 'normal' : 'abnormal';
      });
    } else {
      setState(() {
        condition = '';
      });
    }
  }

  void handlePredictPress() {
    calculateBmi();
    evaluateCondition();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissKeyboard,
      child: Scaffold(
        backgroundColor: Color(0xFFE6EEFF),
        appBar: AppBar(
          backgroundColor: Color(0xFF3D6DCC),
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Predicting using BMI\n',
                  style: TextStyle(
                    fontSize: 18, // Font size for the first line
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'and Volume',
                  style: TextStyle(
                    fontSize: 18, // Font size for the second line
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => dashboard()),
            ),
            color: Colors.white, // Changed back arrow color to white
          ),
          toolbarHeight: 80, // Increased the height of the AppBar
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Age', style: _labelStyle),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
                ),
                onChanged: (value) => setState(() => age = value),
                style: TextStyle(fontSize: 14), // Reduced text size
              ),
              SizedBox(height: 12),
              Text('Gender', style: _labelStyle),
              DropdownButton<String>(
                value: selectedGender,
                items: [
                  DropdownMenuItem(value: 'male', child: Text('Male')),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => selectedGender = value!),
                isExpanded: true,
              ),
              SizedBox(height: 12),
              Text('Height (cm)', style: _labelStyle),
              TextField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
                ),
                onChanged: (value) => setState(() => height = value),
                style: TextStyle(fontSize: 14), // Reduced text size
              ),
              SizedBox(height: 12),
              Text('Weight (kg)', style: _labelStyle),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
                ),
                onChanged: (value) => setState(() => weight = value),
                style: TextStyle(fontSize: 14), // Reduced text size
              ),
              SizedBox(height: 12),
              Text('Enter volume of pituitary gland', style: _labelStyle),
              TextField(
                controller: volumeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '',
                ),
                onChanged: (value) => setState(() => volume = value),
                style: TextStyle(fontSize: 14), // Reduced text size
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: handlePredictPress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D6DCC),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Predict', style: TextStyle(color: Colors.white)),
              ),
              if (bmi != null) ...[
                SizedBox(height: 16),
                Text('BMI: $bmi', style: _resultStyle),
              ],
              if (condition.isNotEmpty) ...[
                SizedBox(height: 16),
                Text('Condition: $condition', style: _resultStyle),
              ],
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _labelStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  TextStyle get _resultStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
