// register_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String name = '';
  String surname = '';
  DateTime? birthdate;
  String gender = 'Male';
  double? weight;
  String username = '';
  String password = '';
  String email = '';

  // Gender options
  final List<String> genderOptions = ['Male', 'Female', 'Do not want to declare'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthdate = picked;
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                        onChanged: (value) => name = value,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Surname'),
                        validator: (value) => value!.isEmpty ? 'Please enter surname' : null,
                        onChanged: (value) => surname = value,
                      ),
                      SizedBox(height: 16),

                      // Birthdate picker
                      ListTile(
                        title: Text('Birthdate: ${birthdate != null ? DateFormat('yyyy-MM-dd').format(birthdate!) : 'Not selected'}'),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),
                      SizedBox(height: 16),

                      // Gender dropdown
                      DropdownButtonFormField<String>(
                        value: gender,
                        decoration: InputDecoration(labelText: 'Gender'),
                        items: genderOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Weight (kg)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter weight';
                          if (double.tryParse(value) == null) return 'Please enter a valid number';
                          return null;
                        },
                        onChanged: (value) => weight = double.tryParse(value),
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) => value!.isEmpty ? 'Please enter username' : null,
                        onChanged: (value) => username = value,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter password';
                          if (value.length < 8) return 'Password must be at least 8 characters';
                          return null;
                        },
                        onChanged: (value) => password = value,
                      ),
                      SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter email';
                          if (!isValidEmail(value)) return 'Please enter a valid email';
                          return null;
                        },
                        onChanged: (value) => email = value,
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed Register button at the bottom
            Container(
              padding: EdgeInsets.all(16.0),
              child: // In the register button's onPressed callback in register_screen.dart
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && birthdate != null) {
                    try {
                      // Save credentials
                      await UserService.saveCredentials(username, password);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration successful! You can now login.'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Verify credentials were saved
                      final savedCreds = await UserService.getCredentials();
                      print('Verified saved credentials: ${savedCreds.toString()}');

                      Navigator.pop(context);
                    } catch (e) {
                      print('Error during registration: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registration failed. Please try again.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }


}