import 'dart:async';
import 'package:brachitek/main_pages/providers/message_provider.dart';
import 'package:brachitek/models/message.dart';
import 'package:brachitek/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  final messageProvider = Get.find<MessageProvider>();
  Rx<User?> user = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxList<Message> messages = <Message>[].obs;
  Timer? _timer;
  TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    user.value = Get.arguments[0];
    fetchMessages();
    isLoading.value = false;

    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await fetchMessages();
    });
  }

  Future<void> fetchMessages() async {
    messages.value =
        await messageProvider.getUserMessages(user.value!.Username) ??
            <Message>[];
  }

  Future<void> sendMessage(String body) async {
    var res = await messageProvider.sendMessage(user.value!.Username, body);
    if (res) {
      messages.add(Message(
        emitter: messageProvider.auth.username.value,
        receiver: user.value!.Username,
        body: body,
        sentAt: DateTime.now().millisecondsSinceEpoch*100000,
      ));
    } else {
      Get.snackbar("Error", "Could not send the message, try again");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    textEditingController.dispose();
    super.onClose();
  }
}
