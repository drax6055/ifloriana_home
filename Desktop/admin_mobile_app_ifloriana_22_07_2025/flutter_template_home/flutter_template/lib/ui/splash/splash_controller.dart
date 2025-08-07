import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/ui/drawer/manager/getManager/getmanagerScreen.dart'
    show Getmanagerscreen;
import 'package:flutter_template/ui/drawer/staff/addNewStaffScreen.dart'
    show Addnewstaffscreen;
import 'package:flutter_template/ui/inhouse/get/inhouseProduct_screen.dart'
    show InhouseproductScreen;
import 'package:get/get.dart';
import '../../route/app_route.dart';
import '../../wiget/custome_snackbar.dart';
import '../buy_product/buy_product_screen.dart';
import '../buy_product/getOrderList/getOrderListScreen.dart';
import '../drawer/branches/getBranches/getBranchesScreen.Dart';
import '../drawer/coupons/couponsScreen.dart';
import '../drawer/customers/addCustomer/addCustomerScreen.dart';
import '../drawer/customers/customersScreen.dart';
import '../drawer/products/brand/getBrandsScreen.dart';
import '../drawer/products/category/CategoryScreen.dart';
import '../drawer/products/subcategory/subcategoryScreen.dart';
import '../drawer/services/categotys/addNewServicesScreen.dart';
import '../inhouse/post/addInhouseProduct_screen.dart';

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
          Get.to(Categoryscreen());
          // Get.to(StaffServiceReportScreen());
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
