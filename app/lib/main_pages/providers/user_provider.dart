import 'dart:io';

import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/models/user.dart';
import 'package:get/get.dart';

class UserProvider extends GetConnect {
  final auth = Get.find<AuthenticationController>();

  Future<User?> getUser(String username) async {
    var response = await get('$api_base_url$users_endpoint/$username');
    print(response.body.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return User(
          Username: response.body['username'],
          Name: response.body['name'] ?? "Jane",
          Surname: response.body['surname'] ?? "Doe",
          Email: response.body['mail'] ?? "janedoe@mail.com",
          Company: response.body['username'] ?? "Dunder Mifflin",
          Role: response.body['role'] ?? "Assistant to the regional manager",
          ProfilePicture: response.body['profile_picture'],
          PhoneNumber: /* response.body['number'] ?? */
              ''); // TODO : number is not within the available fields yet, nor it will be a nullable value
    } else {
      return null;
    }
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
}
