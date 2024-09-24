import 'dart:io';

import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:brachitek/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// To implement
/// profile picture upload
/// company name
/// role
/// mail
/// phone number

class RegistrationController extends GetxController {
  final userProvider = Get.find<UserProvider>();
  final auth = Get.find<AuthenticationController>();
  Rx<File?> profileImage = Rx<File?>(null);

  RxBool isLoading = false.obs;
  RxString phoneNumber = ''.obs;
  RxString name = ''.obs;
  RxString surname = ''.obs;
  RxString company = ''.obs;
  RxString role = ''.obs;
  RxString email = ''.obs;
  RxString username = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  /// used for name, surname, city, company and role
  String? basicTextFieldValidator(String? value) {
    if (value == null || value.length < 3) {
      return "Invalid value";
    } else if (value.length > 31) {
      return "This field must be shorter than 32";
    }
  }

  @override
  onClose() {
    nameController.text = '';
    surnameController.text = '';
    companyController.text = '';
    cityController.text = '';
    roleController.text = '';
    usernameController.text = '';
    phoneController.text = '';
    emailController.text = '';

    super.onClose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    // Regular expression for basic email validation
    String pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // Regular expression for phone number validation
    String pattern =
        r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$";
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  Future<bool> validateCredentials(String username, String email) async {
    isLoading.value = true;
    var response = await userProvider.validateCredentials(username, email);
    isLoading.value = false;
    if (response == null) {
      Get.snackbar("Network Error", "Please retry later");
      return false;
    } else if (response["email"] == true && response["username"] == true) {
      Get.snackbar("Invalid ", "Invalid Username and Mail");
      return false;
    } else if (response["email"] == true) {
      Get.snackbar("Invalid ", "Invalid Mail");
      return false;
    } else if (response["username"] == true) {
      Get.snackbar("Invalid ", "Invalid Username");
      return false;
    }
    return true;
  }

  Future<bool> registerUser() async {
    isLoading.value = true;
    int? statusCode = await userProvider.addUser(
        User(
            username: usernameController.text,
            name: nameController.text,
            surname: surnameController.text,
            email: emailController.text,
            company: companyController.text,
            role: roleController.text,
            phoneNumber: phoneController.text),
        passwordController.text);
    isLoading.value = false;

    if (statusCode == null) {
      Get.snackbar("Network Error", "There has been an error try again later");
      return false;
    } else if (statusCode == 200 || statusCode == 202 || statusCode == 201) {
      await auth.login(usernameController.text, passwordController.text);
      return true;
    } else {
      Get.snackbar("Error", "There has been an error try again");
      return false;
    }
  }

  Future<bool> uploadProfilePicture(File file) async {
    isLoading.value = true;
    bool res = await userProvider.changeProfilePicture(file);
    isLoading.value = false;

    if (res) {
      return true;
    } else {
      Get.snackbar("Error", "Could not upload picture");
      return false;
    }
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length > 10) {
      return 'Usename must be shorter than 10 characters';
    }
    if (value.length < 5) {
      return 'Usename must be longer than 5 characters';
    }

    RegExp regex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!regex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  String? validatePassword(String? value) {
    var errorMessage = '';

    if (value == null) {
      return 'Please enter a password.\n';
    }
    if (value.length < 8) {
      errorMessage += 'Password must be longer than 6 characters.\n';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      errorMessage += '• Uppercase letter is missing.\n';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      errorMessage += '• Lowercase letter is missing.\n';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      errorMessage += '• Digit is missing.\n';
    }
    if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      errorMessage += '• Special character is missing.\n';
    }
    if (errorMessage.isNotEmpty) {
      return errorMessage;
    } else {
      return null;
    }
  }
}
