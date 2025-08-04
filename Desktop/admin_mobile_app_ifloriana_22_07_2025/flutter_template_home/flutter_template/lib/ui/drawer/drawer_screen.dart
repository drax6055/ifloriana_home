import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          title: 'Dashboard', icon: FontAwesomeIcons.gauge, pageIndex: 0),
      DrawerItem(
          title: 'Booking', icon: FontAwesomeIcons.calendarDays, pageIndex: 1),
      DrawerItem(title: 'Branches', icon: Icons.update, pageIndex: 2),
      DrawerItem(
          title: 'Staff', icon: Icons.account_circle_sharp, pageIndex: 3),
      DrawerItem(
          title: 'Profile Update', icon: Icons.account_box, pageIndex: 4),
      DrawerItem(
          title: 'Logout', icon: Icons.logout, pageIndex: 0, isLogout: true),
    ];

    final List<Map<String, dynamic>> pages = [
      {
        'title': 'Dashboard',
        'widget': DashboardScreen(),
        'showAppBar': true,
        'actions': [
          IconButton(
            onPressed: () {
              // Dashboard action
            },
            icon: Icon(Icons.notifications, size: 26.sp),
          ),
        ],
      },
      {
        'title': 'Branches',
        'widget': GetBranchesScreen(),
        'showAppBar': false,
        'actions': [],
      },
      {
        'title': 'Staff',
        'widget': Staffdetailsscreen(),
        'showAppBar': true,
        'actions': [
          IconButton(
            onPressed: () {
              // Staff page action
            },
            icon: Icon(Icons.add, size: 26.sp),
          ),
        ],
      },
      {
        'title': 'Profile Update',
        'widget': Adminprofilescreen(),
        'showAppBar': true,
        'actions': [],
      },
    ];

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: Obx(() {
            final selectedIndex = getController.selectedPage.value;
            if (selectedIndex < pages.length &&
                pages[selectedIndex]['showAppBar'] == true) {
              return CustomAppBar(
                title: getController.appBarTitle.value,
                // actions: pages[selectedIndex]['actions'] ?? [],
              );
            } else {
              return SizedBox.shrink(); // no appbar
            }
          }),
        ),
        body: Obx(() {
          final selectedIndex = getController.selectedPage.value;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (selectedIndex < pages.length) {
              getController.appBarTitle.value = pages[selectedIndex]['title'];
            } else {
              getController.appBarTitle.value = 'Dashboard';
            }
          });

          if (selectedIndex < pages.length) {
            return pages[selectedIndex]['widget'];
          } else {
            return DashboardScreen();
          }
        }),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 10.h),
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
                currentAccountPicture: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    getController.selectPage(4); // Profile page
                  },
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: secondaryColor,
                    child: Obx(() => CustomTextWidget(
                          text: getController.fullname.value.isNotEmpty
                              ? getController.fullname.value[0].toUpperCase()
                              : '',
                          textStyle: CustomTextStyles.textFontMedium(
                              size: 20.sp, color: white),
                        )),
                  ),
                ),
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
                    Navigator.pop(context);
                    if (item.isLogout) {
                      await getController.onLogoutPress();
                    } else {
                      getController.selectPage(item.pageIndex);
                    }
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final int pageIndex;
  final bool isLogout;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.pageIndex,
    this.isLogout = false,
  });
}
