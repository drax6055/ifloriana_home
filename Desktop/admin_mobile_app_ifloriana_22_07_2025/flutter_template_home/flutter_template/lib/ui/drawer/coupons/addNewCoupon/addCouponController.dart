import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/addCoupons.dart';
import 'package:flutter_template/network/model/coupon_model.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/ui/drawer/coupons/couponsController.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Branch {
  final String? id;
  final String? name;

  Branch({this.id, this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Addcouponcontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getBranches();
    // Check if we're in edit mode
    final coupon = Get.arguments as CouponModel?;
    if (coupon != null) {
      isEditMode.value = true;
      editingCouponId.value = coupon.id;
      // Pre-fill the form
      nameController.text = coupon.name ?? '';
      descriptionController.text = coupon.description ?? '';
      coponCodeController.text = coupon.code ?? '';
      discountAmtController.text = coupon.discountAmount?.toString() ?? '';
      userLimitController.text = coupon.useLimit?.toString() ?? '';
      selectedCouponType.value = coupon.type?.capitalize ?? 'Custom';
      selectedDiscountType.value = coupon.discountType?.capitalize ?? 'Percent';
      isActive.value = coupon.status == 1;

      // Format dates to YYYY-MM-DD
      if (coupon.startDate != null) {
        final startDate = DateTime.parse(coupon.startDate!);
        StarttimeController.text =
            "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}";
      }
      if (coupon.endDate != null) {
        final endDate = DateTime.parse(coupon.endDate!);
        EndtimeController.text =
            "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
      }

      // Select branches if they exist
      if (coupon.branchIds != null) {
        selectedBranches.value = branchList
            .where((branch) => coupon.branchIds!.contains(branch.id))
            .toList();
      }
    }
  }

  var isEditMode = false.obs;
  var editingCouponId = RxnString();

  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  var coponCodeController = TextEditingController();
  var discountAmtController = TextEditingController();
  var userLimitController = TextEditingController();
  var isActive = true.obs;
  var selectedCouponType = "Custom".obs;
  var couponList = <CouponModel>[].obs;
  var StarttimeController = TextEditingController();
  var EndtimeController = TextEditingController();
  var branchList = <Branch>[].obs;
  var selectedBranches = <Branch>[].obs;
  bool get allSelected => selectedBranches.length == branchList.length;

  var selectedDiscountType = "Percent".obs;
  final List<String> dropdownCouponTypeItem = [
    'Custom',
    'Bulk',
    'Seasonal',
    'Event'
  ];

  final List<String> dropdownDiscountTypeItem = ['Percent', 'Fixed'];

  // Add this method to handle branch selection after branches are loaded
  void selectBranches(List<String>? branchIds) {
    if (branchIds != null && branchList.isNotEmpty) {
      selectedBranches.value =
          branchList.where((branch) => branchIds.contains(branch.id)).toList();
    }
  }

  Future<void> getBranches() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBranchName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();

      // After branches are loaded, check if we need to select any
      final coupon = Get.arguments as CouponModel?;
      if (coupon != null) {
        selectBranches(coupon.branchIds);
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future onCoupons() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> couponData = {
      "image": null,
      "name": nameController.text,
      "description": descriptionController.text,
      "start_date": StarttimeController.text,
      "end_date": EndtimeController.text,
      "coupon_type": selectedCouponType.value.toLowerCase(),
      "coupon_code": coponCodeController.text,
      "discount_type": selectedDiscountType.value.toLowerCase(),
      "discount_amount": discountAmtController.text,
      "use_limit": userLimitController.text,
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
      "branch_id": selectedBranches.map((e) => e.id).toList(),
    };

    try {
      if (isEditMode.value && editingCouponId.value != null) {
        // Update existing coupon
        await dioClient.putData(
          '${Apis.baseUrl}${Endpoints.coupons}/${editingCouponId.value}?salon_id=${loginUser!.salonId}',
          couponData,
          (json) => json,
        );
        CustomSnackbar.showSuccess('Success', 'Coupon updated successfully');
      } else {
        // Create new coupon
        await dioClient.postData<AddCoupons>(
          '${Apis.baseUrl}${Endpoints.coupons}',
          couponData,
          (json) => AddCoupons.fromJson(json),
        );
        CustomSnackbar.showSuccess('Success', 'Coupon added successfully');
      }

      var updateList = Get.put(CouponsController());
      updateList.getCoupons();
      Get.back();
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
