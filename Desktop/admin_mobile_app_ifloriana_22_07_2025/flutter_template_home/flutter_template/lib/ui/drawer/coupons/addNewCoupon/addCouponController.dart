import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/addCoupons.dart';
import 'package:flutter_template/network/model/coupon_model.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/ui/drawer/coupons/couponsController.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;

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
      // Pre-fill image
      singleImage.value = null;
      editImageUrl.value = coupon.image_url ?? '';
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
    } else {
      singleImage.value = null;
      editImageUrl.value = '';
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

  final Rx<File?> singleImage = Rx<File?>(null);
  final RxString editImageUrl = ''.obs;

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

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    editImageUrl.value = '';
    if (pickedFile != null) {
      singleImage.value = File(pickedFile.path);
    }
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    editImageUrl.value = '';
    if (pickedFile != null) {
      singleImage.value = File(pickedFile.path);
    }
  }

  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    coponCodeController.clear();
    discountAmtController.clear();
    userLimitController.clear();
    StarttimeController.clear();
    EndtimeController.clear();
    isActive.value = true;
    selectedCouponType.value = 'Custom';
    selectedDiscountType.value = 'Percent';
    selectedBranches.clear();
    singleImage.value = null;
    editImageUrl.value = '';
  }

  String? _getMimeType(String path) {
    final ext = path.toLowerCase();
    if (ext.endsWith('.jpg') || ext.endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (ext.endsWith('.png')) {
      return 'image/png';
    }
    return null;
  }

  Future onCoupons() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> couponData = {
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
      dio.FormData? formData;
      // Add image if selected
      if (singleImage.value != null) {
        final mimeType = _getMimeType(singleImage.value!.path);
        if (mimeType == null) {
          CustomSnackbar.showError(
              'Invalid Image', 'Only JPG, JPEG, PNG images are allowed!');
          return;
        }
        final mimeParts = mimeType.split('/');
        couponData['image'] = await dio.MultipartFile.fromFile(
          singleImage.value!.path,
          filename: singleImage.value!.path.split(Platform.pathSeparator).last,
          contentType: MediaType(mimeParts[0], mimeParts[1]),
        );
      } else if (editImageUrl.value.isNotEmpty) {
        couponData['image'] = editImageUrl.value;
      }
      formData = dio.FormData.fromMap(couponData);

      if (isEditMode.value && editingCouponId.value != null) {
        // Update existing coupon
        await dioClient.dio.put(
          '${Apis.baseUrl}${Endpoints.coupons}/${editingCouponId.value}?salon_id=${loginUser!.salonId}',
          data: formData,
          options:
              dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
        );
        CustomSnackbar.showSuccess('Success', 'Coupon updated successfully');
      } else {
        // Create new coupon
        await dioClient.dio.post(
          '${Apis.baseUrl}${Endpoints.coupons}',
          data: formData,
          options:
              dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
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
