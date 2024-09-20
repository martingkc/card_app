import 'package:brachitek/login_register/login_page.dart';
import 'package:brachitek/login_register/register_page_1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section with dark blue background (80% height)
          Expanded(
            flex: 8,
            child: Container(
              color: Colors.blue[900], // Dark blue background
              child: Center(
                child: Text(
                  '', // Empty placeholder for now, can add content here later
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          
          // Bottom section with white background (20% height)
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white, // White background
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Login Button (Flat, square edges)
                    SizedBox(
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black, // Black background
                          iconColor: Colors.white, // White text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Square edges
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed('/login');
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Register Button (Flat, square edges)
                    SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // Square edges
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed('/register_1');
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    // Continue as Guest
                   
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
