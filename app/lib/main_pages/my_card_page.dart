import 'package:brachitek/main_pages/controllers/mycard_controller.dart';
import 'package:brachitek/models/platforms.dart';
import 'package:brachitek/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:io';

class MyCardScreen extends StatelessWidget {
  final MyCardController controller = Get.put(MyCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Card'),
        actions: [
          // Add a button that appears only when there are unsaved changes
          Obx(() {
            return controller.isModified.value
                ? IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      await controller.saveChanges();
                    },
                  )
                : SizedBox.shrink(); // Hide if there are no changes
          }),
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Section with Editable Image
              buildProfileSection(),
              SizedBox(height: 20),
              // Dynamically generated list items
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      // Extract the platform and the URL from the map
                      final platform = controller.items[index].keys.first;
                      final url = controller.items[index].values.first;

                      // Call _buildListItem with the extracted platform and URL
                      return _buildListItem(platform, url, index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.showInputDialog(null); // Show dialog to add a new item
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
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
            // Edit Icon
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  await controller.pickImage(); // Call method to pick an image
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black,
                  child: Icon(Icons.edit, color: Colors.white, size: 16),
                ),
              ),
            ),
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
                  '${controller.user.value?.Name ?? ""} ${controller.user.value?.Surname ?? ""}', // Display name and surname
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                // Display role and company
                Text(
                  '${controller.user.value?.Role ?? ""} at ${controller.user.value?.Company ?? ""}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
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
        leading: FaIcon(platform.icon,
            color: Colors.black), // Get icon from Platforms enum
        title: Text('${platform.name}'), // Display platform name and URL
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            controller.showItemMenu(index); // Show item menu for modify/remove
          },
        ),
        onTap: () {
          Get.snackbar('Tapped', 'You tapped on ${platform.name}');
        },
      ),
    );
  }
}
