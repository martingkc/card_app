import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/models/conversations.dart';
import 'package:brachitek/models/message.dart';
import 'package:brachitek/models/user.dart';
import 'package:get/get.dart';

class MessageProvider extends GetConnect {
  final auth = Get.find<AuthenticationController>();

  Future<List<Conversation>?> getChats() async {
    var token = await auth.getBearerToken();
    List<Conversation> ret = [];
    var response = await get(
      '$api_base_url$message/$retrieve_chats',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var element in response.body) {
        var user = element['user'];
        var message = element['last_message'];
        ret.add(
         Conversation(user:  User(
              company: user['company'] ?? '',
              username: user['username'],
              name: user['name'],
              surname: user['surname'],
              email: user['email'],
              phoneNumber: user['phoneNumber'],
              profilePicture: user['profile_picture'],
              role: user['role']), 
              lastMessage: Message(emitter: message['issuer'], receiver: message['recipient'], body: message['body'], sentAt: message['timestamp']))
        );
      }

      return ret;
    }
    return null;
  }

  Future<List<Message>?> getUserMessages(String username) async {
    var token = await auth.getBearerToken();
    List<Message> ret = [];
    var response = await post(
      '$api_base_url$message/$retrieve_messages',
      {"username": "$username"},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      for (var element in response.body) {
        ret.add(Message(
            emitter: element['issuer'],
            receiver: element['recipient'],
            body: element['body'],
            sentAt: element['timestamp']));
      }
      ret.sort((a, b) => a.sentAt.compareTo(b.sentAt));

      for (var r in ret) {
        print(r.body);
        print(r.sentAt);
      }

      return ret;
    }
    return null;
  }

  Future<bool> sendMessage(String username, String body) async {
    var token = await auth.getBearerToken();
    var response = await post(
      '$api_base_url$message/$send',
      {"username": "$username", "message": "$body"},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202) {
      return true;
    }
    return false;
  }
}
