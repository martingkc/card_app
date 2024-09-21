import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/models/user.dart';
import 'package:get/get.dart';

class ContactProvider extends GetConnect {
  final auth = Get.find<AuthenticationController>();

  Future<List<User>?> getFollowers() async {
    var token = await auth.getBearerToken();

    List<User> ret = [];
    var response = await get(
      '$api_base_url$users_endpoint/$following',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      for (var element in response.body) {
        ret.add(User(
            Username: element['username'] ?? '',
            Name: element['name'] ?? '',
            Surname: element['surname'] ?? '',
            Email: element['email'] ?? '',
            Company: element['company'] ?? '',
            Role: element['role'] ?? '',
            PhoneNumber: element['phoneNumber'] ?? '',
            ProfilePicture: element['profilePicture'] ?? ''));
      }
      return ret;
    } else {
      return null;
    }
  }

  Future<bool> followUser(String username) async {
    var token = await auth.getBearerToken();
    print(token);
    final response = await post(
      "$api_base_url$users_endpoint/$follow",
      {"username": '$username'},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unfollowUser(String username) async {
    var token = await auth.getBearerToken();
    final response = await post(
      "$api_base_url$users_endpoint/$unfollow",
      {"username": '$username'},
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, List<User>>?> searchUsers(String query) async {
    Map<String, List<User>> ret = {};
    var response = await get(
      '$api_base_url$users_endpoint/$search/$query',
    );
    if (response.statusCode == 200) {
      var body = response.body;
      List<User> matchesByName = [];
      List<User> matchesByUsername = [];
      for (var user in body['fullname_matches']) {
        matchesByName.add(User(
            Username: user['username'],
            Company: user['company'],
            Name: user['name'],
            Surname: user['surname'],
            Email: user['email'],
            Role: user['role'],
            PhoneNumber: user['phoneNumber'],
            ProfilePicture: user['profile_picture'] ?? ''));
      }
      for (var user in body['username_matches']) {
        matchesByUsername.add(User(
            Username: user['username'],
            Company: user['company'] ?? '',
            Name: user['name'] ?? '',
            Surname: user['surname'] ?? '',
            Email: user['email'] ?? '',
            Role: user['role'] ?? '',
            PhoneNumber: user['phoneNumber'] ?? '',
            ProfilePicture: user['profile_picture'] ?? ''));
      }
      ret['username'] = matchesByUsername;
      ret['name'] = matchesByName;
      return ret;
    }
    return null;
  }
}
