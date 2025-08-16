import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/auth/profile/adminProfileScreen.dart';
import 'package:flutter_template/ui/drawer/branches/getBranches/getBranchesScreen.Dart';

import 'package:flutter_template/ui/drawer/drawer_controller.dart';
import 'package:flutter_template/ui/drawer/staff/staffDetailsScreen.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../utils/custom_text_styles.dart';
import '../../wiget/appbar/commen_appbar.dart';
import 'dashboard/dashboard_screen.dart';
class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DrawermenuController getController = Get.put(DrawermenuController());

    final List<DrawerItem> drawerItems = [
      DrawerItem(
          title: 'Dashboard',
          icon: FontAwesomeIcons.gauge,
          route: Routes.dashboardScreen),
      DrawerItem(
          title: 'Booking',
          icon: FontAwesomeIcons.calendarDays,
          route: Routes.gerStaff),
      DrawerItem(title: 'Branches', icon: Icons.update, route: Routes.getBranches),
      DrawerItem(
          title: 'Staff', icon: Icons.account_circle_sharp, route: Routes.getCoupons),
      DrawerItem(
          title: 'Profile Update', icon: Icons.account_box, route: Routes.addService),
    ];

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            accountName: Obx(() => CustomTextWidget(
                  text: getController.fullname.value.toString(),
                  textStyle: CustomTextStyles.textFontMedium(
                      size: 14.sp, color: white),
                )),
            accountEmail: Obx(() => CustomTextWidget(
                  text: getController.email.value,
                  textStyle: CustomTextStyles.textFontMedium(
                      size: 14.sp, color: white),
                )),
          ),
          ...drawerItems.map((item) {
            return ListTile(
              dense: true,
              leading: Icon(item.icon, size: 18.sp),
              title: CustomTextWidget(
                text: item.title,
                textStyle: CustomTextStyles.textFontMedium(size: 13.sp),
              ),
              onTap: () async {
                Navigator.pop(context); // close drawer
                if (item.isLogout) {
                  await getController.onLogoutPress();
                } else {
                  Get.offAllNamed(item.route); // navigate to screen
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final String route;
  final bool isLogout;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isLogout = false,
  });
}
