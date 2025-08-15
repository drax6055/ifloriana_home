import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/ui/auth/register/register_screen.dart';
import 'package:flutter_template/ui/drawer/branches/getBranches/getBranchesScreen.Dart'
    show GetBranchesScreen;
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../buy_product/getOrderList/getOrderListScreen.dart';
import '../drawer/Branchmembership/get/branchMembershipListScreen.dart';
import '../drawer/branchPackages/getBranchPackagesScreen.dart';
import '../drawer/commission/commission_list_screen.dart';
import '../drawer/coupons/couponsScreen.dart';

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
          Get.to(GetBranchPackagesScreen());
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
