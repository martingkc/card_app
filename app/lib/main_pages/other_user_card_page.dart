import 'package:brachitek/main_pages/controllers/follower_card_controller.dart';
import 'package:brachitek/main_pages/message_page.dart';
import 'package:brachitek/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:brachitek/models/platforms.dart'; // For Platforms enum

class UserCardPage extends StatelessWidget {
  final FollowerCardController controller = Get.put(FollowerCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildProfileSection(),
              SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final platform = controller.items[index].keys.first;
                      final url = controller.items[index].values.first;

                      return _buildListItem(platform, url, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the profile section with a pen icon to edit the image
  Widget buildProfileSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            // Profile Image
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.imagePath.value.isNotEmpty
                        ? (controller.imagePath.value.startsWith('http')
                            ? NetworkImage(controller.imagePath.value)
                                as ImageProvider
                            : FileImage(File(controller.imagePath.value)))
                        : null,
                    child: controller.imagePath.value.isEmpty
                        ? Icon(Icons.person, size: 60)
                        : null, // Placeholder if no image
                  )),
          ],
        ),
        SizedBox(height: 10),
        // User's Name and Surname
        Obx(() {
          if (controller.isLoading.value || controller.user.value == null) {
            return CircularProgressIndicator(); // Display loading indicator
          } else {
            return Column(
              children: [
                Text(
                  '${controller.user.value?.name ?? ""} ${controller.user.value?.surname ?? ""}', // Display name and surname
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Display role and company
                Text(
                  '${controller.user.value?.role ?? ""} at ${controller.user.value?.company ?? ""}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Add the "Send Message" and "Follow" buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                       Get.to(MessagePage(), arguments: [controller.user.value]); 
                      },
                      icon: Icon(Icons.message, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.blue, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    if(!controller.isFollowing.value)
                    IconButton(
                      onPressed: () async {
                        await controller.follow(controller.user.value!.username); 
                      },
                      icon: Icon(Icons.person_add, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.green, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                    else
                    IconButton(
                      onPressed: () async {
                        await controller.unfollow(controller.user.value!.username); 
                      },
                      icon: Icon(Icons.person_remove, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.green, // Background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        }),
      ],
    );
  }

  // Method to build each list item with black borders and no elevation
  Widget _buildListItem(Platforms platform, String url, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black, width: 1),
      ),
      elevation: 0,
      child: ListTile(
        leading: FaIcon(platform.icon, color: Colors.black), // Get icon from Platforms enum
        title: Text('${platform.name}'), // Display platform name and URL
        onTap: () async {
          Uri _url = Uri.parse(url);
          await launchUrl(_url);
        },
      ),
    );
  }
}
