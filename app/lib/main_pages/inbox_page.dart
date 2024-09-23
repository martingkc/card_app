import 'package:brachitek/constraints.dart';
import 'package:brachitek/models/conversations.dart';
import 'package:brachitek/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brachitek/main_pages/controllers/inbox_controller.dart';
import 'package:brachitek/models/user.dart';

class InboxPage extends StatelessWidget {
  final InboxController controller = Get.put(InboxController());

  @override
  Widget build(BuildContext context) {
    // Search controller (optional)
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          // You can add actions here if needed
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar (optional)
            // If you want to add a search functionality
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: TextField(
            //     controller: searchController,
            //     decoration: InputDecoration(
            //       hintText: 'Search',
            //       prefixIcon: Icon(Icons.search, color: Colors.grey),
            //       border: OutlineInputBorder(
            //         borderSide: BorderSide.none,
            //         borderRadius: BorderRadius.zero,
            //       ),
            //       filled: true,
            //       fillColor: Colors.grey[200],
            //     ),
            //     onChanged: (value) {
            //       // Implement search filtering here
            //       controller.filterConversations(value);
            //     },
            //   ),
            // ),
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.chats.isEmpty) {
                  return Center(child: Text('No messages found.'));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchChats(); // Refresh the inbox
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.chats.length,
                      itemBuilder: (context, index) {
                        var conversation = controller.chats[index];
                        return _buildConversationCard(conversation);
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

  // Conversation Card Widget
  Widget _buildConversationCard(Conversation conversation) {
    User user = conversation.user;
    String lastMessage = conversation.lastMessage.body ?? '';
    String timestamp = conversation.lastMessage.sentAt != null
        ? formatTimestamp(DateTime.fromMicrosecondsSinceEpoch((conversation.lastMessage.sentAt/10000).toInt()))
        : '';

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
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: Text(
          timestamp,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        onTap: () {
          Get.toNamed('/message', arguments: [user]);
        },
      ),
    );
  }

  // Helper method to format the timestamp
  String formatTimestamp(DateTime timestamp) {
    // Implement your desired formatting here
    // For example, return formatted date or time
    // You can use the intl package for formatting dates
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
