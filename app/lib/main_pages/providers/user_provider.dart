import 'dart:io';

import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/models/user.dart';
import 'package:get/get.dart';

class UserProvider extends GetConnect {
  final auth = Get.find<AuthenticationController>();

  Future<User?> getUser(String username) async {
    var response = await get('$api_base_url$users_endpoint/$username');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User(
          username: response.body['username'],
          name: response.body['name'] ?? "Jane",
          surname: response.body['surname'] ?? "Doe",
          email: response.body['mail'] ?? "janedoe@mail.com",
          company: response.body['username'] ?? "Dunder Mifflin",
          role: response.body['role'] ?? "Assistant to the regional manager",
          profilePicture: response.body['profile_picture'],
          phoneNumber: /* response.body['number'] ?? */
              ''); // TODO : number is not within the available fields yet, nor it will be a nullable value
    } else {
      return null;
    }
  }

  Future<Map<String, bool>?> validateCredentials(
      String username, String email) async {
    var response = await post('$api_base_url$validate_username_mail',
        {"username": "$username", "email": "$email"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        "email": response.body["email_exists"],
        "username": response.body["username_exists"]
      };
    }
    return null; 
  }

  Future<bool> changeProfilePicture(File file) async {
    var token = await auth.getBearerToken();

    if (!file.existsSync()) {
      return false;
    }

    final form = FormData({
      'files': MultipartFile(file, filename: file.path.split('/').last),
    });

    final response = await post(
        "$api_base_url$change_profile_picture",
        headers: {
          'Authorization': 'Bearer $token',
        },
        form);
    if (response.hasError) {
      return false;
    }
    return true;
  }

  Future<int?> addUser(User user, String password) async {
    var body = user.serialize();
    body.addAll({'password': password});

    var response = await put("$api_base_url$register", body);

    return response.statusCode;
  }
}
