import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:brachitek/main_pages/controllers/message_controller.dart';
import 'package:brachitek/models/message.dart';

class MessagePage extends StatelessWidget {
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = controller.user.value;
          return Text(user != null ? '${user.Name} ${user.Surname}' : 'Chat');
        }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    reverse: true, // Show latest messages at the bottom
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final message = controller
                          .messages[controller.messages.length - 1 - index];
                      final isMine = message.emitter ==
                          controller.messageProvider.auth.username.value;
                      return Align(
                        alignment:
                            isMine ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMine ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message.body,
                            style: TextStyle(
                                color: isMine ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            Divider(height: 1),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (text) {
                        controller.sendMessage(text);
                        controller.textEditingController.clear();
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final text = controller.textEditingController.text.trim();
                      if (text.isNotEmpty) {
                        controller.sendMessage(text);
                        controller.textEditingController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
