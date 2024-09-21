import 'package:brachitek/models/message.dart';
import 'package:brachitek/models/user.dart';

class Conversation {
  User user;
  Message lastMessage;

  Conversation({required this.user, required this.lastMessage});
}