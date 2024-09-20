import 'package:brachitek/main_pages/controllers/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Globalmiddleware extends GetMiddleware{
  final authController = Get.find<AuthenticationController>();
  
  /// GETX middleware function that verifys whether the user is authenticated or not everytime it makes a route request in a route that uses this middleware
  @override
  RouteSettings? redirect(String? route){
    if(authController.isAuthenticated.value == false){
      return RouteSettings(name: '/welcome');
    }
    return null;
  }
}