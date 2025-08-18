import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/drawer/drawer_controller.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:flutter_template/wiget/custome_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../utils/custom_text_styles.dart';
import 'branches/getBranches/getBranchesController.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({super.key});
  final getController = Get.put(Getbranchescontroller());
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
          route: Routes.appointment),
      DrawerItem(
          title: 'Branches', icon: Icons.update, route: Routes.getBranches),
      // ✅ Services will be expandable
      DrawerItem(
        title: 'Services',
        icon: Icons.account_circle_sharp,
        route: '', // parent doesn’t navigate
        subItems: [
          DrawerItem(
              title: 'List', icon: Icons.local_offer, route: Routes.addService),
          DrawerItem(
              title: 'Category',
              icon: Icons.add_circle,
              route: Routes.addNewCategotyScreen),
          DrawerItem(
              title: 'Sub Category',
              icon: Icons.add_circle,
              route: Routes.addService),
        ],
      ),
      DrawerItem(
          title: 'Packages',
          icon: Icons.account_box,
          route: Routes.GetBranchPackagesScreen),

      DrawerItem(
          title: 'Membership',
          icon: Icons.account_box,
          route: Routes.addBranchMembership),
      DrawerItem(
          title: 'Customer Package',
          icon: Icons.account_box,
          route: Routes.CustomerPackageReportScreen),

      // DrawerItem(
      //   title: 'Logout',
      //   icon: Icons.logout,
      //   route: '',
      //   isLogout: true,
      // ),
    ];

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            currentAccountPicture: CircleAvatar(
              radius: 25,
              backgroundColor: secondaryColor, // optional for contrast
              child: Obx(() {
                final name = getController.fullname.value;
                final firstLetter =
                    name.isNotEmpty ? name[0].toUpperCase() : '?';
                return Text(
                  firstLetter,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: white, // match your theme
                  ),
                );
              }),
            ),
            accountName: Obx(() => CustomTextWidget(
                  text: getController.fullname.value.toString(),
                  textStyle: CustomTextStyles.textFontMedium(
                      size: 12.sp, color: white),
                )),
            accountEmail: Obx(() => CustomTextWidget(
                  text: getController.email.value,
                  textStyle: CustomTextStyles.textFontMedium(
                      size: 12.sp, color: white),
                )),
          ),
          ...drawerItems.map((item) {
            if (item.subItems.isNotEmpty) {
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  dense: true,
                  leading: Icon(item.icon, size: 18.sp),
                  title: CustomTextWidget(
                    text: item.title,
                    textStyle: CustomTextStyles.textFontMedium(size: 13.sp),
                  ),
                  children: item.subItems.map((sub) {
                    return ListTile(
                      dense: true,
                      leading: Icon(sub.icon, size: 16.sp),
                      title: CustomTextWidget(
                        text: sub.title,
                        textStyle: CustomTextStyles.textFontMedium(size: 12.sp),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        if (sub.isLogout) {
                          await getController.onLogoutPress();
                        } else {
                          Get.offAllNamed(sub.route);
                        }
                      },
                    );
                  }).toList(),
                ),
              );
            } else {
              // ✅ Normal list tile
              return ListTile(
                dense: true,
                leading: Icon(item.icon, size: 18.sp),
                title: CustomTextWidget(
                  text: item.title,
                  textStyle: CustomTextStyles.textFontMedium(size: 13.sp),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  if (item.isLogout) {
                    await getController.onLogoutPress();
                  } else {
                    Get.offAllNamed(item.route);
                  }
                },
              );
            }
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
  final List<DrawerItem> subItems;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.route,
    this.isLogout = false,
    this.subItems = const [],
  });
}
