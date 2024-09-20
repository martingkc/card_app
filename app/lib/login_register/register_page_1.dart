import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage1 extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.offAndToNamed('/welcome');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "What's your name?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),

              // First Name Input
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Surname Input
              TextField(
                controller: surnameController,
                decoration: InputDecoration(
                  labelText: 'Surname',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              Spacer(),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    iconColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed('/register_2'); // Navigate to next page
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color:Colors.white ,fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
