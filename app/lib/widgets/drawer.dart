import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthenticationController>(); 
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Optional header for the drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[900], // Dark blue header background
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Drawer sections
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('My Card'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Get.offAndToNamed('/my_card');
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'),
            onTap: () {
              // Handle Inbox action
              Navigator.pop(context); // Close the drawer
              Get.toNamed('/inbox');
            },
          ),
          ListTile(
            leading: Icon(Icons.contacts),
            title: Text('My Contacts'),
            onTap: () {
              // Handle My Contacts action
              Navigator.pop(context); // Close the drawer

              Get.offAndToNamed('/my_contacts');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Handle Settings action
              Get.snackbar('Navigation', 'Navigating to Settings');
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              
              Navigator.pop(context); 
              authController.logout();
            },
          ),
        ],
      ),
    );
  }
}
