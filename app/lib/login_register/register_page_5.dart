import 'dart:io';
import 'package:brachitek/login_register/controllers/registration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage5 extends GetView<RegistrationController> {
  final ImagePicker _picker = ImagePicker();

  RegisterPage5({Key? key}) : super(key: key);

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Save the selected image file to the controller
      controller.profileImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected.');
    }
  }

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
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  "Pick a profile picture",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : null,
                      child: controller.profileImage.value == null
                          ? Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                              size: 50,
                            )
                          : null,
                    ),
                  ),
                ),
                const Spacer(),
                // Finish Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            iconColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () async {
                            if (controller.profileImage.value != null) {
                              bool success = await controller.uploadProfilePicture(
                                  controller.profileImage.value!);
                              if (success) {
                                // Navigate to the next page or home
                                Get.offAllNamed('/my_card');
                              }
                            } else {
                              Get.snackbar('Error',
                                  'Please select a profile picture.');
                            }
                          },
                          child: const Text(
                            'Finish',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ),
      ),
    );
  }
}
