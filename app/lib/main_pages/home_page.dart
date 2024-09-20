import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  // Create a GlobalKey to control the ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black), // Hamburger menu icon
          onPressed: () {
            // Use the key to open the drawer
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      
        centerTitle: true,
      ),
      // Side Drawer (Hamburger Menu)
      drawer: Drawer(
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
                // Handle My Card action
                Get.snackbar('Navigation', 'Navigating to My Card');
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.inbox),
              title: Text('Inbox'),
              onTap: () {
                // Handle Inbox action
                Get.snackbar('Navigation', 'Navigating to Inbox');
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts),
              title: Text('My Contacts'),
              onTap: () {
                // Handle My Contacts action
                Get.snackbar('Navigation', 'Navigating to My Contacts');
                Navigator.pop(context); // Close the drawer
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
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title "Your Insights"
              Text(
                "Your insights for this week",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20), // Spacing below the title

              // Row with the cards (Tracked Pages, Page Views, Viewers)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tracked Pages Card
                  _buildInsightCard(
                    iconData: Icons
                        .message, // Replace with the appropriate icon
                    backgroundColor: Colors.purple[100]!,
                    title: 'Contact Requests',
                    value: '116',
                  ),

                  // Page Views Card
                  _buildInsightCard(
                    iconData: Icons.visibility,
                    backgroundColor: Colors.green[100]!,
                    title: 'Page views',
                    value: '5.3K',
                  ),

                  // Viewers Card
                  _buildInsightCard(
                    iconData: Icons.person,
                    backgroundColor: Colors.blue[100]!,
                    title: 'New Contacts',
                    value: '2.5K',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to create individual insight cards
Widget _buildInsightCard({
  required IconData iconData,
  required Color backgroundColor,
  required String title,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    width: 100, // Set a width for each card
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 5,
          spreadRadius: 2,
          offset: Offset(0, 3), // Shadow position
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon inside a rounded background
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, size: 30, color: Colors.black),
        ),
        SizedBox(height: 10),

        // Title
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5),

        // Value
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
