import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/utils/colors.dart';
import '../../../wiget/appbar/commen_appbar.dart';
import 'appointmentController.dart';

class PaymentSummaryScreen extends StatelessWidget {
  final dynamic a; // pass appointment object

  PaymentSummaryScreen({Key? key, required this.a}) : super(key: key);

  final controller = Get.find<AppointmentController>();

  @override
  Widget build(BuildContext context) {
    final state = controller.paymentSummaryState;

    return Scaffold(
      appBar: CustomAppBar(title: "Payment Summary"),
      body: Obx(() {
        final selectedTax = state.selectedTax.value;
        final tips = double.tryParse(state.tips.value) ?? 0.0;
        final paymentMethod = state.paymentMethod.value;
        final coupon = state.appliedCoupon.value;
        final couponDiscount = coupon != null
            ? (coupon.discountType == 'percentage'
                ? a.amount * coupon.discountAmount / 100
                : coupon.discountAmount)
            : 0.0;
        final addAdditionalDiscount = state.addAdditionalDiscount.value;
        final discountType = state.discountType.value;
        final discountValue = double.tryParse(state.discountValue.value) ?? 0.0;
        final memberDiscount = a.branchMembershipDiscount ?? 0.0;
        final taxValue =
            selectedTax != null ? selectedTax.value * a.amount / 100 : 0.0;

        controller.calculateGrandTotal(
          servicePrice: a.amount.toDouble(),
          memberDiscount: memberDiscount,
          taxValue: taxValue,
          tip: tips,
          couponDiscount: couponDiscount,
          additionalDiscount: addAdditionalDiscount ? discountValue : 0.0,
          discountType: discountType,
        );

        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date: ${a.date}",
                  style: TextStyle(color: Colors.black87, fontSize: 14.sp)),
              SizedBox(height: 6),
              Text("Customer Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp)),
              Text("Name: ${a.clientName}",
                  style: TextStyle(color: Colors.black87)),
              Text("Phone: ${a.clientPhone ?? ''}",
                  style: TextStyle(color: Colors.black87)),
              SizedBox(height: 10),
              Text("Service Amount: ₹ ${a.amount}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              Divider(color: Colors.grey[400]),
              Text("Billing Details",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor)),
              SizedBox(height: 12),

              /// 🔹 TAX + TIPS + PAYMENT METHOD
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      value: selectedTax,
                      items: controller.taxes
                          .map((tax) => DropdownMenuItem(
                                value: tax,
                                child: Text('${tax.title} (${tax.value}%)'),
                              ))
                          .toList(),
                      onChanged: (val) => state.selectedTax.value = val,
                      decoration: InputDecoration(labelText: "Tax"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: state.tips.value,
                      onChanged: (val) => state.tips.value = val,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: "Tips"),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: paymentMethod,
                      items: ["UPI", "Cash", "Card"]
                          .map((m) =>
                              DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) state.paymentMethod.value = val;
                      },
                      decoration: InputDecoration(labelText: "Payment Method"),
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[400]),

              /// 🔹 DISCOUNTS
              Text("Discounts",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      fontSize: 18)),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: state.couponCode.value,
                      onChanged: (val) => state.couponCode.value = val,
                      decoration: InputDecoration(labelText: "Coupon Code"),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                      onPressed: () =>
                          controller.applyCoupon(state.couponCode.value),
                      child: Text("Apply")),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: addAdditionalDiscount,
                      onChanged: (val) =>
                          state.addAdditionalDiscount.value = val ?? false),
                  Text("Add additional discount?",
                      style: TextStyle(color: Colors.black87)),
                ],
              ),
              if (addAdditionalDiscount)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: discountType,
                        items: [
                          DropdownMenuItem(
                              value: "percentage", child: Text("Percentage")),
                          DropdownMenuItem(value: "amount", child: Text("Amount"))
                        ],
                        onChanged: (val) {
                          if (val != null) state.discountType.value = val;
                        },
                        decoration: InputDecoration(labelText: "Discount Type"),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        initialValue: state.discountValue.value,
                        onChanged: (val) => state.discountValue.value = val,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: "Discount Value"),
                      ),
                    )
                  ],
                ),
              Divider(color: Colors.grey[400]),

              /// 🔹 GRAND TOTAL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Grand Total",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18)),
                  Text("₹ ${state.grandTotal.value.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 22)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Get.back(),
                      child: Text("Cancel", style: TextStyle(color: Colors.red))),
                  SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: generate bill API
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[300]),
                    child: Text("Generate Bill"),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
