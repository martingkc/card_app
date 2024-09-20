import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/providers/card_provider.dart';
import 'package:brachitek/main_pages/providers/follower_provider.dart';
import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:brachitek/models/platforms.dart';
import 'package:brachitek/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowerCardController extends GetxController {
  final cardProvider = Get.find<CardProvider>();
  final userProvider = Get.find<UserProvider>();
  final contactProvider = Get.find<ContactProvider>();
  RxString imagePath = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isModified = false.obs;
  RxBool isFollowing = false.obs;

  Rxn<User> user = Rxn<User>();

  @override
  onInit() async {
    dynamic argumentData = Get.arguments;
    user.value = argumentData[0];
    var followers = await contactProvider.getFollowers();
    if (followers != null && followers.map((e) => e.Username).toList().contains(user.value!.Username)) {
      isFollowing.value = true;
    }
    user.value?.ProfilePicture == ''
        ? imagePath.value = ''
        : imagePath.value = "$api_base_url$files/${user.value?.ProfilePicture}";

    await refreshPage();
    print(profileImagePath.value);
    super.onInit();
  }

  // Text editing controllers for new inputs
  TextEditingController inputController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();

  // List to store added items as RxList<Map<Platforms, String>>
  RxList<Map<Platforms, String>> items = <Map<Platforms, String>>[].obs;
  RxList<Map<Platforms, String>> serverItems = <Map<Platforms, String>>[].obs;

  RxString profileImagePath = ''.obs;

  // Dialog options for adding new items
  List<Platforms> options = Platforms.values.toList();

  Future<void> refreshPage() async {
    isLoading.value = true;
    items.value = await cardProvider.getCards(user.value!.Username) ??
        <Map<Platforms, String>>[];

    isLoading.value = false;
  }

  Future<void> launchCard(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> follow(String username) async {
    var res = await contactProvider.followUser(username);
    if (res) {
      Get.snackbar('$username added to followers', '');
      isFollowing.value = true;
    } else {
      Get.snackbar('Error', 'Something unexpected happened try again.');
    }
  }
  Future<void> unfollow(String username) async {
    var res = await contactProvider.unfollowUser(username);
    if (res) {
      Get.snackbar('$username removed from followers', '');
      isFollowing.value = false;
    } else {
      Get.snackbar('Error', 'Something unexpected happened try again.');
    }
  }
}
