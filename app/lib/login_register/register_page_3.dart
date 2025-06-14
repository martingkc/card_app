import 'package:brachitek/login_register/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage3 extends GetView<RegistrationController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.offAndToNamed('/welcome');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey, // Assign the form key
              child: Obx(
                () {
                  if (!controller.isLoading.value) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          "Create a password",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Password Input
                        TextFormField(
                          controller: controller.passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true, // Hide the password text
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: controller.validatePassword,
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password Input
                        TextFormField(
                          controller: controller.passwordConfirmController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true, // Hide the password text
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value !=
                                controller.passwordConfirmController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const Spacer(),

                        // Next Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black,
                              iconColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Get.toNamed('/register_4');
                              }
                            },
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.black, width: 1.5),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero, // Square edges
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
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
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
        ),
      ),
    );
  }
}
