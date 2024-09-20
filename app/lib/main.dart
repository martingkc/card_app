import 'package:brachitek/login_register/controllers/login_controller.dart';
import 'package:brachitek/login_register/login_page.dart';
import 'package:brachitek/login_register/register_page_1.dart';
import 'package:brachitek/login_register/register_page_2.dart';
import 'package:brachitek/login_register/register_page_3.dart';
import 'package:brachitek/login_register/welcome_page.dart';
import 'package:brachitek/main_pages/other_user_card_page.dart';
import 'package:brachitek/main_pages/contacts_page.dart';
import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:brachitek/main_pages/my_card_page.dart';
import 'package:brachitek/main_pages/providers/card_provider.dart';
import 'package:brachitek/main_pages/providers/follower_provider.dart';
import 'package:brachitek/main_pages/providers/user_provider.dart';
import 'package:brachitek/middlewares/globalMiddleware.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  var auth = Get.put(AuthenticationController());

  /// TODO: fix this shit
  await auth.refreshToken();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/my_card',
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<AuthenticationController>(() => AuthenticationController());
        Get.lazyPut<CardProvider>(() => CardProvider());

        Get.lazyPut<UserProvider>(() => UserProvider());
      }),
      getPages: [
        GetPage(
            name: '/login',
            page: () => LoginScreen(),
            binding: BindingsBuilder(() {
              Get.lazyPut<LoginController>(() => LoginController());
            })),
        GetPage(name: '/welcome', page: () => WelcomeScreen()),
        GetPage(name: '/register_1', page: () => RegisterPage1()),
        GetPage(name: '/register_2', page: () => RegisterPage2()),
        GetPage(name: '/register_3', page: () => RegisterPage3()),
        GetPage(
            name: '/my_card',
            page: () => MyCardScreen(),
            middlewares: [Globalmiddleware()],
            binding: BindingsBuilder(() {
              Get.lazyPut(() => CardProvider());
              Get.lazyPut(() => UserProvider());
            })),
        GetPage(
            name: '/my_contacts',
            page: () => FollowersPage(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => ContactProvider());
            })),
        GetPage(
            name: '/contact',
            page: () => UserCardPage(),
            binding: BindingsBuilder(() {
              Get.lazyPut(() => UserProvider());
              Get.lazyPut(() => CardProvider());
            }))
      ],
    );
  }
}
