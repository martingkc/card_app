import 'package:brachitek/constraints.dart';
import 'package:brachitek/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brachitek/main_pages/controllers/follower_controller.dart';
import 'package:brachitek/models/user.dart';

class FollowersPage extends StatelessWidget {
  final ContactsController controller = Get.put(ContactsController());

  @override
  Widget build(BuildContext context) {
    // Search controller
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Obx(() {
            if (controller.isSearching.value) {
              return IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  controller.clearSearch();
                  searchController.clear();
                },
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (value) async {
                  if (value.trim().isNotEmpty) {
                    await controller.searchUser(value.trim());
                  }
                },
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  // Optionally implement live search here
                },
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.isSearching.value) {
                  // Display search results
                  return buildSearchResults();
                } else if (controller.followedUsers.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                } else {
                  // Sort the contacts alphabetically
                  List<User> sortedList = List<User>.from(controller.followedUsers)
                    ..sort((a, b) {
                      String nameA = '${a.name ?? ''} ${a.surname ?? ''}';
                      String nameB = '${b.name ?? ''} ${b.surname ?? ''}';
                      return nameA.compareTo(nameB);
                    });

                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.updateFollowers(); // Refresh the contacts list
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: sortedList.length,
                      itemBuilder: (context, index) {
                        User user = sortedList[index];
                        return _buildContactCard(user);
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Contact Card Widget
  Widget _buildContactCard(User user) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.profilePicture!.isNotEmpty
              ? NetworkImage("$api_base_url$files/${user.profilePicture!}")
              : null,
          child: user.profilePicture == null || user.profilePicture!.isEmpty
              ? Icon(Icons.person, size: 30, color: Colors.black)
              : null,
          backgroundColor: Colors.grey[200],
        ),
        title: Text(
          '${user.name ?? ''} ${user.surname ?? ''}',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          '${user.company ?? ''}',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        onTap: () {
          // Handle tap on contact card
          Get.toNamed('/contact', arguments: [user]);
        },
      ),
    );
  }

  // Build Search Results
  Widget buildSearchResults() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  if (controller.searchResults.containsKey('name') && controller.searchResults['name']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Matches by Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...controller.searchResults['name']!.map((user) => _buildSearchResultCard(user)).toList(),
                      ],
                    ),
                  if (controller.searchResults.containsKey('username') && controller.searchResults['username']!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text('Matches by Username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        ...controller.searchResults['username']!.map((user) => _buildSearchResultCard(user)).toList(),
                      ],
                    ),
                  if ((controller.searchResults['name'] == null || controller.searchResults['name']!.isEmpty) &&
                      (controller.searchResults['username'] == null || controller.searchResults['username']!.isEmpty))
                    Center(child: Text('No results found.')),
                ],
              ),
            ),
          ],
        );
      }
    });
  }

  // Search Result Card Widget
  Widget _buildSearchResultCard(User user) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Colors.black, width: 1),
      ),
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.profilePicture != null && user.profilePicture!.isNotEmpty
              ? NetworkImage("$api_base_url$files/${user.profilePicture!}")
              : null,
          child: user.profilePicture!.isEmpty
              ? Icon(Icons.person, size: 30, color: Colors.black)
              : null,
          backgroundColor: Colors.grey[200],
        ),
        title: Row(
          children: [
            Text(
              '${user.name ?? ''} ${user.surname ?? ''}',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(width: 8),
            Text(
              '@${user.username ?? ''}',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        subtitle: Text(
          '${user.company ?? ''}',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        onTap: () {
          Get.toNamed('/contact', arguments: [user]);
        },
      ),
    );
  }
}
