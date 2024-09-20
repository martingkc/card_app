import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final authController = Get.find<AuthenticationController>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void onUsernameFieldChanged(String value ){
    usernameController.text = value; 
  }

  void onPasswordFieldChanged(String value ){
    passwordController.text = value; 
  }
}
