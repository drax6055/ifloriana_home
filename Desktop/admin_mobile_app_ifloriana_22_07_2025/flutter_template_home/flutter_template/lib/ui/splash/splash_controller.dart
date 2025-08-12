import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/ui/drawer/customers/customersScreen.dart'
    show CustomersScreen;
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../drawer/branches/getBranches/getBranchesScreen.Dart';
import '../drawer/branches/post_branches_screena.dart/postBranchesScreen.dart';
import '../drawer/services/addServices/addservicesScreen.dart';
import '../drawer/staff/staffDetailsScreen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNextScreen();
  }

  navigateToNextScreen() async {
    try {
      var duration = const Duration(seconds: 2);

      Timer(duration, () async {
        final user = await prefs.getUser();
        final managerUser = await prefs.getManagerUser();

        String? accessToken = user?.token;
        String? managerAccessToken = managerUser?.token;

        if (accessToken != null && accessToken.isNotEmpty) {
          Get.to(Staffdetailsscreen());
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
