import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage2 extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
                "How can we contact you?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30),

              // Phone Number Input
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
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

              // Email Input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
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
                    Get.toNamed('/register_3'); // Navigate to next page
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Square edges
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
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
