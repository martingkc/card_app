import 'package:brachitek/login_register/controllers/login_controller.dart';
import 'package:brachitek/login_register/register_page_1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends GetView<LoginController> {
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
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Welcome Text (Larger and Aligned to the Left)
              const Align(
                alignment: Alignment.centerLeft, // Align the text to the left
                child: Text(
                  "Welcome back! \nGlad to see you, Again!",
                  style: TextStyle(
                    fontSize: 32, // Bigger text size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left, // Align the text to the left
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              // Email Input (TextField with line style)
               TextField(
                onChanged: controller.onUsernameFieldChanged,
                decoration: const InputDecoration(
                  labelText: 'Mail',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                textAlign: TextAlign.left, // Align the text to the left
              ),
              const SizedBox(height: 20),

              // Password Input (TextField with line style)
              TextField(
                onChanged: controller.onPasswordFieldChanged,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                textAlign: TextAlign.left, // Align the text to the left
              ),
              SizedBox(height: 40),

              // Login Button (Black, square, and flat)
              Expanded(
                flex: 2, // Push login button down
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black, // Black background
                          iconColor: Colors.white, // White text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius
                                .zero, // Square edges (no border radius)
                          ),
                        ),
                        onPressed: () async {
                         bool logged = await controller.authController.login(controller.usernameController.text, controller.passwordController.text); 
                         if(logged == true){
                          Get.toNamed("/my_card");
                         }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Register Now Text + Forgot Password Text below it
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(RegisterPage1());
                          },
                          child: Text(
                            'Don’t have an account? Register Now',
                            style: TextStyle(
                              color: Colors.grey[700], // Dark grey
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Forgot password action
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.grey[700], // Dark grey
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
