import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// To implement
/// profile picture upload
/// company name
/// role
/// mail
/// phone number

class RegistrationController extends GetxController {
  final userProvider = Get.find<UserProvider>();
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

  Future<void> registerUser() async {
    //userProvider.addUser(user, password)
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
