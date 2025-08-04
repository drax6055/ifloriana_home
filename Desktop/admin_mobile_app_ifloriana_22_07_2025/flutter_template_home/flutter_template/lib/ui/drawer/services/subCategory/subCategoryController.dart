import 'package:flutter/widgets.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Category {
  final String? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String? categoryId;
  final int? status;

  SubCategory(
      {required this.id, required this.name, this.categoryId, this.status});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    String? categoryId;
    if (json['category_id'] is String) {
      categoryId = json['category_id'];
    } else if (json['category_id'] is Map<String, dynamic>) {
      categoryId = json['category_id']['_id'];
    }

    return SubCategory(
      id: json['_id'],
      name: json['name'],
      categoryId: categoryId,
      status: json['status'],
    );
  }
}

class Subcategorycontroller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getCategorys();
    getSubCategory();
  }

  var branchList = <Category>[].obs;
  var selectedBranch = Rx<Category?>(null);
  var nameController = TextEditingController();
  var isActive = true.obs;
  var subCategoryList = <SubCategory>[].obs;

  Future<void> getCategorys() async {
    final loginUser = await prefs.getUser();
    try {
      var response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getServiceCategotyName}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      branchList.value = data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      print("==> ${e.toString()}");
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> getSubCategory() async {
    final loginUser = await prefs.getUser();
    try {
      var response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getSubCategory}${loginUser!.salonId}',
        (json) => json,
      );
      final data = response['data'] as List;
      subCategoryList.value = data.map((e) => SubCategory.fromJson(e)).toList();
    } catch (e) {
      print("==> ${e.toString()}");
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> deleteSubCategory(String? subCategoryId) async {
    final loginUser = await prefs.getUser();
    if (subCategoryId == null) return;
    try {
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.addSubCategory}/$subCategoryId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      subCategoryList.removeWhere((s) => s.id == subCategoryId);
      getSubCategory();
      CustomSnackbar.showSuccess('Deleted', 'Subcategory removed successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete subcategory: $e');
    }
  }

  Future onaddNewSubcategory() async {
    final loginUser = await prefs.getUser();

    Map<String, dynamic> staffData = {
      "name": nameController.text,
      "image": null,
      "salon_id": loginUser!.salonId,
      "category_id": selectedBranch.value?.id,
      'status': isActive.value ? 1 : 0,
    };
    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.addSubCategory}',
        staffData,
        (json) => json,
      );
      getSubCategory();
      CustomSnackbar.showSuccess('Success', 'Staff added successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> onEditSubcategory(SubCategory subCategory) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> data = {
      "name": nameController.text,
      "image": null,
      "category_id": selectedBranch.value?.id,
      'status': isActive.value ? 1 : 0,
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.addSubCategory}/${subCategory.id}/?salon_id=${loginUser!.salonId}',
        data,
        (json) => json,
      );
      getSubCategory();
      CustomSnackbar.showSuccess('Success', 'Subcategory updated successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
