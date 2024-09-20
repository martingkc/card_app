import 'dart:convert';
import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/models/platforms.dart';
import 'package:get/get.dart';

/// TODO: add the various server response codes to the cases

class CardProvider extends GetConnect {
  final auth = Get.find<AuthenticationController>();

  Future<List<Map<Platforms, String>>?> getCards(String username) async {
    var response = await get('$api_base_url$contact_info/$username');
    List<Map<Platforms, String>> ret = [];
    print(response.body.toString());
    if (response.statusCode == 200) {
      for (var element in response.body) {
        Platforms platform =
            Platforms.values.firstWhere((e) => e.name == element['platform']);

        ret.add({platform: element['link']});
      }
      return ret;
    } else {
      return null;
    }
  }

  Future<bool> updateCards(List<Map<Platforms, String>> cards) async {
    var token = await auth.getBearerToken();
    var data = jsonEncode(cards
        .map((e) => {
              'platform': e.keys.first.name, // Access the name of the enum key
              'link': e.values.first // Access the corresponding link (value)
            })
        .toList());

    print(data);

    var response = await post('$api_base_url$update_card', '{"items": $data}',
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
