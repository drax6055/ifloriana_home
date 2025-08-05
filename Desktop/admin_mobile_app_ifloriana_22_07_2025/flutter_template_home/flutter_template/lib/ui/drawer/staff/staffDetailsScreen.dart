import 'package:flutter/material.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/drawer/staff/staffDetailsController.dart';
import 'package:flutter_template/utils/app_images.dart';
import 'package:flutter_template/utils/colors.dart';
import 'package:get/get.dart';

import '../../../wiget/loading.dart';
import '../../../ui/drawer/staff/addNewStaffScreen.dart';

class Staffdetailsscreen extends StatelessWidget {
  final Staffdetailscontroller controller = Get.put(Staffdetailscontroller());

  Staffdetailsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          controller.getCustomerDetails();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CustomLoadingAvatar());
          }

          if (controller.staffList.isEmpty) {
            return const Center(child: Text("No staff found"));
          }

          return ListView.builder(
            itemCount: controller.staffList.length,
            itemBuilder: (context, index) {
              final staff = controller.staffList[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: CircleAvatar(
                      radius: 30, backgroundImage: AssetImage(AppImages.applogo)
                      // backgroundImage: staff.image != null &&
                      //         staff.image!.isNotEmpty
                      //     ? NetworkImage(staff.image!)
                      //     : const AssetImage("assets/default.png") as ImageProvider,
                      ),
                  title: Text(
                    staff.fullName ?? "Unknown",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (staff.email != null) Text("Email: ${staff.email}"),
                      if (staff.branchId?.name != null)
                        Text("Branch: ${staff.branchId!.name}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: primaryColor),
                        onPressed: () {
                          Get.to(() => Addnewstaffscreen(staff: staff));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: primaryColor),
                        onPressed: () {
                          _confirmDelete(context, staff.sId ?? '', controller);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.toNamed(Routes.addNewStaff);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, String staffId, Staffdetailscontroller controller) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this staff?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.deleteStaff(staffId);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
