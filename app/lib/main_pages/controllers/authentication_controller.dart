import 'package:brachitek/constraints.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


/// TODO: fix the token generator this way of fetching it is fucking horrible 
class AuthenticationController extends GetxController {
  static AuthenticationController get to => Get.find();

  @override
  onInit() async {
    super.onInit();
 
  }

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  RxBool isAuthenticated = false.obs;

  RxString bearerToken = ''.obs;
  DateTime? tokenCreationTime;
  int tokenTTL = ttl; // Token time to live in seconds

  final String _tokenKey = 'bearerToken';
  final String _tokenCreationKey = 'tokenCreationTime';
  final String _usernameKey = 'username';
  final String _passwordKey = 'password';

  RxString username = ''.obs;  

  void _loadTokenFromStorage() async {
    String? token = await _secureStorage.read(key: _tokenKey);
    String? creationTimeString =
        await _secureStorage.read(key: _tokenCreationKey);

    if (token != null && creationTimeString != null) {
      bearerToken.value = token;
      tokenCreationTime = DateTime.parse(creationTimeString);
    }
  }

  Future<bool> login(String username, String password) async {
    var auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    var response = await http.get(
      Uri.parse(api_base_url + login_endpoint),
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': auth
      },
    );

    if (response.statusCode == 200) {
      // Assume response contains the bearer token
      var data = jsonDecode(response.body);
      String token = data['token'];
      bearerToken.value = token;
      tokenCreationTime = DateTime.now();

      // Save credentials and token to secure storage
      await _secureStorage.write(key: _usernameKey, value: username);
      await _secureStorage.write(key: _passwordKey, value: password);
      await _secureStorage.write(key: _tokenKey, value: token);
      await _secureStorage.write(
          key: _tokenCreationKey, value: tokenCreationTime!.toIso8601String());
      isAuthenticated.value = true;
      return true;
    } else {
      // Handle login failure
      Get.snackbar('Login Failed', 'Invalid username or password');
      isAuthenticated.value = false;
      return false;
    }
  }

  Future<String?> getBearerToken() async {
    if (bearerToken.value.isEmpty || tokenCreationTime == null) {
      // No token available, prompt login
      _promptLogin();
      return null;
    }

    int elapsedTime = DateTime.now().difference(tokenCreationTime!).inSeconds;
    int timeLeft = tokenTTL - elapsedTime;

    if (timeLeft <= 100) {
      bool success = await refreshToken();
      if (!success) {
        _promptLogin();
        return null;
      }
    }

    return bearerToken.value;
  }

  Future<bool> refreshToken() async {
    // Use stored credentials to obtain a new token
    String? username = await _secureStorage.read(key: _usernameKey);
    String? password = await _secureStorage.read(key: _passwordKey);

    if (username == null || password == null) {
      // No stored credentials, prompt login
      this.username.value = ''; 
      return false;
    }

    var auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    var response = await http.get(
      Uri.parse(api_base_url + login_endpoint),
      headers: <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': auth
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String token = data['token'];
      bearerToken.value = token;
      tokenCreationTime = DateTime.now();

      // Update token in secure storage
      await _secureStorage.write(key: _tokenKey, value: token);
      await _secureStorage.write(
          key: _tokenCreationKey, value: tokenCreationTime!.toIso8601String());
      isAuthenticated.value = true;
      this.username.value = username; 
      return true;
    } else {
      return false;
    }
  }

  void _promptLogin() {
    // Navigate to login screen
    Get.toNamed('/login');
  }

  Future<void> logout() async {
    // Clear stored credentials and token
    await _secureStorage.delete(key: _usernameKey);
    await _secureStorage.delete(key: _passwordKey);
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _tokenCreationKey);

    bearerToken.value = '';
    tokenCreationTime = null;

    // Navigate to login screen
    Get.offAllNamed('/welcome');
  }
}
