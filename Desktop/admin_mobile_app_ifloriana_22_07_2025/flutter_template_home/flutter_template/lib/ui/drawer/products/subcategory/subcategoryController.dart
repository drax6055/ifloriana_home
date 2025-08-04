import 'package:flutter/widgets.dart';
import 'package:flutter_template/network/model/productSubCategory.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';

class Branch1 {
  final String? id;
  final String? name;

  Branch1({this.id, this.name});

  factory Branch1.fromJson(Map<String, dynamic> json) {
    return Branch1(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class Subcategorys {
  final String? id;
  final String? name;

  Subcategorys({this.id, this.name});

  factory Subcategorys.fromJson(Map<String, dynamic> json) {
    return Subcategorys(
      id: json['_id'],
      name: json['name'],
    );
  }
}

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

class Subcategorycontroller extends GetxController {
  final subCategories = <ProductSubCategory>[].obs;
  final isLoading = false.obs;
  var isActive = true.obs;
  var branchList = <Branch1>[].obs;
  var categoryList = <Category>[].obs;

  var brandList = <Subcategorys>[].obs;
  var selectedCategory = Rx<Category?>(null);
  var selectedBranches = <Branch1>[].obs;
  var selectedBrand = <Subcategorys>[].obs;
  var nameController = TextEditingController();
  final branchController = MultiSelectController<Branch1>();
  final brandController = MultiSelectController<Subcategorys>();

  @override
  void onInit() {
    super.onInit();
    getSubCategories();
    getBranches();
    getBrand();
    getCatedory();
  }

  @override
  void onClose() {
    nameController.dispose();
    branchController.dispose();
    super.onClose();
  }

  Future<void> getSubCategories() async {
    final loginUser = await prefs.getUser();
    try {
      isLoading.value = true;
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getProductSubCategories}${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null && response['data'] != null) {
        final List<dynamic> data = response['data'];
        subCategories.value =
            data.map((json) => ProductSubCategory.fromJson(json)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSubCategory(String subCategoryId) async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();

      final response = await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.productSubcategory}/$subCategoryId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      if (response != null) {
        subCategories
            .removeWhere((subCategory) => subCategory.id == subCategoryId);
        getSubCategories();
        CustomSnackbar.showSuccess(
            'Success', 'SubCategory deleted successfully');
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete subcategory: $e');
    } finally {
      isLoading.value = false;
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
      branchList.value = data.map((e) => Branch1.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
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
      brandList.value = data.map((e) => Subcategorys.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> getCatedory() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getproductName}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      categoryList.value = data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future onAddSubCategory() async {
  
    final loginUser = await prefs.getUser();
    Map<String, dynamic> subCategoryData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
      'product_category_id': selectedCategory.value!.id,
      'brand_id': selectedBrand.map((brand) => brand.id).toList(),
    };

    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.productSubcategory}',
        subCategoryData,
        (json) => json,
      );
      Get.back(); 
      getSubCategories();
      resetForm(); 
       CustomSnackbar.showSuccess(
          'Success', 'SubCategory Added Successfully'); 
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> updateSubCategory(String subCategoryId) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> subCategoryData = {
      "image": null,
      "name": nameController.text,
      'branch_id': selectedBranches.map((branch) => branch.id).toList(),
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
      'product_category_id': selectedCategory.value!.id,
      'brand_id': selectedBrand.map((brand) => brand.id).toList(),
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.productSubcategory}/$subCategoryId',
        subCategoryData,
        (json) => json,
      );
      await getSubCategories();
      Get.back();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'SubCategory updated successfully');
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
}
