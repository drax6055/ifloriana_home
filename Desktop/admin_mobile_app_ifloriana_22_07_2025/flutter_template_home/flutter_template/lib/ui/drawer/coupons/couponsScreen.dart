import 'package:flutter/material.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:flutter_template/ui/drawer/coupons/couponsController.dart';
import 'package:get/get.dart';

class CouponsScreen extends StatelessWidget {
  CouponsScreen({super.key});
  final CouponsController getController = Get.put(CouponsController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Obx(() {
        if (getController.couponList.isEmpty) {
          return const Center(child: Text("No coupons available"));
        }
        return ListView.builder(
          itemCount: getController.couponList.length,
          itemBuilder: (context, index) {
            final coupon = getController.couponList[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                title: Text(coupon.name ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type: ${coupon.type ?? '-'}"),
                    Text("Discount Type: ${coupon.discountType ?? '-'}"),
                    Text("Use Limit: ${coupon.useLimit ?? 0}"),
                    Text(
                      "Status: ${coupon.status == 1 ? 'Active' : 'Deactive'}",
                      style: TextStyle(
                        color: coupon.status == 1 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        Get.toNamed(Routes.addCoupon, arguments: coupon);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await getController.deleteCoupon(coupon.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.addCoupon);
        },
        child: Icon(Icons.add),
      ),
    ));
  }
}
