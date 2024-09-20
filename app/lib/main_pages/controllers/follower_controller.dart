import 'package:brachitek/constraints.dart';
import 'package:brachitek/main_pages/providers/follower_provider.dart';
import 'package:brachitek/models/user.dart';
import 'package:get/get.dart';

class ContactsController extends GetxController {
  final contactProvider = Get.find<ContactProvider>();
  RxList<User> followedUsers = <User>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxMap<String, List<User>> searchResults = <String, List<User>>{}.obs;

  @override
  void onInit() async {
    super.onInit();
    await updateFollowers();
  }

  Future<void> updateFollowers() async {
    isLoading.value = true;
    var list = await contactProvider.getFollowers();
    if (list != null) {
      followedUsers.value = list;
    } else {
      Get.snackbar('Error', 'Please retry again');
    }
    isLoading.value = false;
  }

  Future<void> searchUser(String query) async {
    isSearching.value = true;
    isLoading.value = true;

    Map<String, List<User>> searchResult = await contactProvider.searchUsers(query) ?? {};
    searchResults.value = searchResult;

    isLoading.value = false;
  }

  void clearSearch() {
    isSearching.value = false;
    searchResults.clear();
  }
}
