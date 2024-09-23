import 'dart:io';

import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/providers/card_provider.dart';
import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:brachitek/models/platforms.dart';
import 'package:brachitek/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

// Enum for different platforms

class MyCardController extends GetxController {
  final cardProvider = Get.find<CardProvider>();
  final userProvider = Get.find<UserProvider>();
  RxString imagePath = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isModified = false.obs;

  Rxn<User> user = Rxn<User>();

  final ImagePicker picker = ImagePicker();
  @override
  onInit() async {
    super.onInit();
    await refreshPage();
  }

  // Text editing controllers for new inputs
  TextEditingController inputController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();

  // List to store added items as RxList<Map<Platforms, String>>
  RxList<Map<Platforms, String>> items = <Map<Platforms, String>>[].obs;
  RxList<Map<Platforms, String>> serverItems = <Map<Platforms, String>>[].obs;

  RxString profileImagePath = ''.obs;

  // Dialog options for adding new items
  List<Platforms> options = Platforms.values.toList();

  Future<void> refreshPage() async {
    isLoading.value = true;
    items.value =
        await cardProvider.getCards(cardProvider.auth.username.value) ??
            <Map<Platforms, String>>[];
    user.value = await userProvider.getUser(userProvider.auth.username.value);
    imagePath.value = "$api_base_url$files/${user.value?.profilePicture}";
    isLoading.value = false;
  }

  // Function to add an item to the list
  void addItem(Platforms platform, String url) {
    items.add({platform: url});
    isModified.value = true; 
    Get.back(); // Close dialog
  }

  void setProfileImagePath(String path) {
    profileImagePath.value = path;
  }

// Method to show input dialog for adding or modifying
  void showInputDialog(int? index) {
    // Filter options to exclude platforms that are already selected
    List<Platforms> availablePlatforms = options.where((platform) {
      return !items.any((item) => item.keys.contains(platform));
    }).toList();

    // If no platforms are available, show a message
    if (availablePlatforms.isEmpty) {
      Get.snackbar('Info', 'All platforms have been selected.');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: Text(index == null ? 'Add New Item' : 'Modify Item'),
        content: Container(
          height: 400,
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availablePlatforms.length,
                  itemBuilder: (context, optionIndex) {
                    return ListTile(
                      leading: FaIcon(availablePlatforms[optionIndex].icon),
                      title: Text(availablePlatforms[optionIndex].name),
                      onTap: () {
                        Get.back(); // Close current dialog
                        if (index == null) {
                          _showAddLinkInputDialog(
                              availablePlatforms[optionIndex]);
                        } else {
                          _showEditLinkInputDialog(
                              index, availablePlatforms[optionIndex]);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Method to show link input dialog for adding a new item
// Method to show link input dialog for adding a new item
  void _showAddLinkInputDialog(Platforms platform) {
    inputController.clear();
    Get.dialog(
      AlertDialog(
        title: Text('Add ${platform.name} link'),
        content: TextField(
          controller: inputController,
          decoration: InputDecoration(
            hintText: platform == Platforms.Instagram
                ? 'Enter your Instagram username'
                : 'Paste your ${platform.name} link here',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (inputController.text.isNotEmpty) {
                String input = inputController.text;

                // Special handling for Instagram username
                if (platform == Platforms.Instagram) {
                  // Remove leading @ symbol if present
                  if (input.startsWith('@')) {
                    input = input.substring(1); // Remove the '@'
                  }
                  // Create Instagram link
                  input = 'https://instagram.com/$input';
                }

                addItem(platform, input); // Add the item
              }
            },
            child: Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Method to show link input dialog for modifying an existing item
  // Method to show link input dialog for modifying an existing item
  void _showEditLinkInputDialog(int index, Platforms platform) {
    inputController.clear();
    String currentValue = items[index][platform] ?? '';

    // Pre-fill the field with the username if it's Instagram
    if (platform == Platforms.Instagram) {
      currentValue = currentValue.replaceFirst('https://instagram.com/', '');
      
    }
    inputController.text = currentValue;

    Get.dialog(
      AlertDialog(
        title: Text('Edit ${platform.name} link'),
        content: TextField(
          controller: inputController,
          decoration: InputDecoration(
            hintText: platform == Platforms.Instagram
                ? 'Enter your Instagram username'
                : 'Paste your new ${platform.name} link here',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (inputController.text.isNotEmpty) {
                String input = inputController.text;

                // Special handling for Instagram username
                if (platform == Platforms.Instagram) {
                  if (input.startsWith('@')) {
                    input = input.substring(1); // Remove leading '@'
                  }
                  // Create Instagram link
                  input = 'https://instagram.com/$input';
                }

                // Update the item with the new value
                items[index] = {platform: input};
                isModified.value = true; 
                Get.back(); // Close the dialog
              }
            },
            child: Text('Modify'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Function to show the menu (modify/remove) for a card
  void showItemMenu(int index) {
    Get.dialog(
      AlertDialog(
        title: Text('Choose an action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Modify'),
              onTap: () {
                Get.back(); // Close dialog and show modification option
                showInputDialog(index);
              },
            ),
            ListTile(
              title: Text('Remove'),
              onTap: () {
                items.removeAt(index); 
                isModified.value = true; // Remove item from list
                Get.back(); // Close dialog
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close dialog
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var result = await userProvider.changeProfilePicture(File(image.path));
        if (!result) {
          Get.snackbar('Error', 'Unable to update image, retry.');
        } else {
          await refreshPage();
        }
      } else {
        Get.snackbar('Error', 'Unable to access the selected image.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while picking the image: $e');
    }
  }

  Future<void> saveChanges() async {
    var res = await cardProvider.updateCards(items); 

    if(res != true){
      Get.snackbar('Error', 'An error occurred while saving, retry later.');
    }else{
       await refreshPage();

       isModified.value = false;
    }
  }
}
