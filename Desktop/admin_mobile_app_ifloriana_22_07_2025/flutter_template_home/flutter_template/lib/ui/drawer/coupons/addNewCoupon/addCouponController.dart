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
import 'package:multi_dropdown/multi_dropdown.dart';

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
    } else {
      singleImage.value = null;
      editImageUrl.value = '';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    coponCodeController.dispose();
    discountAmtController.dispose();
    userLimitController.dispose();
    StarttimeController.dispose();
    EndtimeController.dispose();
    super.onClose();
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

      print('Coupon getBranches response: $response');
      final data = response['data'] as List;
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
      print('Coupon branchList length: ${branchList.length}');
      print(
          'Coupon branchList: ${branchList.map((b) => '${b.name} (${b.id})').toList()}');

      // After branches are loaded, check if we need to select any
      final coupon = Get.arguments as CouponModel?;
      if (coupon != null && coupon.branchIds != null) {
        selectBranches(coupon.branchIds);
      }
    } catch (e) {
      print('Coupon getBranches error: $e');
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    editImageUrl.value = '';
    await _handlePickedFile(pickedFile);
  }

  Future<void> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    editImageUrl.value = '';
    await _handlePickedFile(pickedFile);
  }

  Future<void> _handlePickedFile(XFile? pickedFile) async {
    const maxSizeInBytes = 150 * 1024; // 150 KB
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final mimeType = _getMimeType(pickedFile.path);
      if (mimeType == null) {
        CustomSnackbar.showError(
            'Invalid Image', 'Only JPG, JPEG, PNG images are allowed!');
        return;
      }
      if (await file.length() < maxSizeInBytes) {
        singleImage.value = file;
      } else {
        CustomSnackbar.showError('Error', 'Image size must be less than 150KB');
      }
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
        Get.back();
      } else {
        await dioClient.dio.post(
          '${Apis.baseUrl}${Endpoints.coupons}',
          data: formData,
          options:
              dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
        );
        Get.back();
      }
      var updateList = Get.put(CouponsController());
      await updateList.getCoupons();
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
