import 'dart:async';

import 'package:brachitek/main_pages/providers/message_provider.dart';
import 'package:brachitek/models/conversations.dart';
import 'package:brachitek/models/user.dart';
import 'package:get/get.dart';

class InboxController extends GetxController {
  final messageProvider = Get.find<MessageProvider>();
  RxList<Conversation> chats =<Conversation>[].obs;  
  RxBool isLoading = false.obs;
  Timer? _timer;
  void onInit() async{
    super.onInit();
    isLoading.value = true;
    fetchChats();
    isLoading.value = false;

    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await fetchChats();
    });
  }

  Future<void> fetchChats() async {
    chats.value = await messageProvider.getChats() ?? chats.value;
  }
}
