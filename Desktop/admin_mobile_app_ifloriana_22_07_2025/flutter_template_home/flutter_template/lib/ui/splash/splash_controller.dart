import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../drawer/appointment/addNewAppointment/newAppointmentScreen.dart';
import '../drawer/appointment/appointmentScreen.dart';
import '../drawer/products/allProducts/addProductsScreen.dart';
import '../drawer/products/product_list/product_list_screen.dart';


class SplashController extends GetxController {
  @override

  navigateToNextScreen() async {
    try {
      var duration = const Duration(seconds: 2);

      Timer(duration, () async {
        final user = await prefs.getUser();
        final managerUser = await prefs.getManagerUser();

        String? accessToken = user?.token;
        String? managerAccessToken = managerUser?.token;

        if (accessToken != null && accessToken.isNotEmpty) {
          Get.to(Newappointmentscreen());
          // Get.offNamed(Routes.drawerScreen); // Regular user
        } else if (managerAccessToken != null &&
            managerAccessToken.isNotEmpty) {
          Get.offNamed(Routes.managerDashboard); // Manager user
        } else {
          Get.offNamed(Routes.loginScreen); // Not logged in
        }
      });
    } catch (e) {
      CustomSnackbar.showError('Error', '$e');
    }
  }
}
