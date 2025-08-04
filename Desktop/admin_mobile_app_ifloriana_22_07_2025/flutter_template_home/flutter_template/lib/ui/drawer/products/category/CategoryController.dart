import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';
import '../../../../network/model/category_model.dart' as model;
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

typedef Brand = model.Brand;
typedef Branch1 = model.Branch;

class Categorycontroller extends GetxController {
  RxList<model.Category> categories = <model.Category>[].obs;
  RxBool isLoading = false.obs;
  var nameController = TextEditingController();
  var isActive = true.obs;
  var selectedBrand = <Brand>[].obs;
  final brandController = MultiSelectController<Brand>();
  var brandList = <Brand>[].obs;
  var selectedBranches = <Branch1>[].obs;
  var branchList = <Branch1>[].obs;
  final branchController = MultiSelectController<Branch1>();

  @override
  void onInit() {
    super.onInit();

    getCategories();
    getBrand();
    getBranches();
  }

  Future<void> getCategories() async {
    isLoading.value = true;
    final loginUser = await prefs.getUser();
    try {
      await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getAllCategory}${loginUser!.salonId}',
        (json) {
          final response = model.CategoryResponse.fromJson(json);
          categories.value = response.data;
          return json;
        },
      );
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getBrand() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getBrandName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      brandList.value = data.map((e) => model.Brand.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
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
      branchList.value = data.map((e) => model.Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future onAddSubCategory() async {
    if (nameController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please enter subcategory name');
      return;
    }

    if (selectedBranches.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select at least one branch');
      return;
    }

    if (selectedBrand.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select at least one brand');
      return;
    }

    final loginUser = await prefs.getUser();
    Map<String, dynamic> subCategoryData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
      'brand_id': selectedBrand.map((brand) => brand.id).toList(),
    };

    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.postSubCategory}',
        subCategoryData,
        (json) => json,
      );
      getCategories();
      Get.back(); // Close the bottom sheet
      resetForm();
      CustomSnackbar.showSuccess(
          'Success', 'SubCategory Added Successfully'); // Reset the form
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  void resetForm() {
    nameController.clear();
    isActive.value = true;
    selectedBranches.clear();
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.postSubCategory}/$categoryId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      // Refresh the categories list
      await getCategories();
      CustomSnackbar.showSuccess('Success', 'Category deleted successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showDeleteConfirmation(
      String categoryId, String categoryName) async {
    deleteCategory(categoryId);
  }

  Future<void> updateCategory(String categoryId) async {
    if (nameController.text.isEmpty) {
      CustomSnackbar.showError('Error', 'Please enter category name');
      return;
    }
    if (selectedBranches.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select at least one branch');
      return;
    }
    if (selectedBrand.isEmpty) {
      CustomSnackbar.showError('Error', 'Please select at least one brand');
      return;
    }
    final loginUser = await prefs.getUser();
    Map<String, dynamic> categoryData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
      'brand_id': selectedBrand.map((brand) => brand.id).toList(),
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.postSubCategory}/$categoryId',
        categoryData,
        (json) => json,
      );
      await getCategories();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'Category updated successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
