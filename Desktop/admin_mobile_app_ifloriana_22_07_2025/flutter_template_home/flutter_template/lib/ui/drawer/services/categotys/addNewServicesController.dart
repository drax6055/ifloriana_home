import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class CreateServiceCategory {
  String? id;
  String? name;
  String? image;
  int? status;

  CreateServiceCategory({this.id, this.name, this.image, this.status});

  factory CreateServiceCategory.fromJson(Map<String, dynamic> json) {
    return CreateServiceCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
    );
  }
}

class AddNewCategotyController extends GetxController {
  var nameController = TextEditingController();
  var isActive = true.obs;

  RxList<CreateServiceCategory> serviceList = <CreateServiceCategory>[].obs;
  RxBool isEditing = false.obs;
  Rxn<CreateServiceCategory> editingItem = Rxn<CreateServiceCategory>();

  @override
  void onInit() {
    super.onInit();
    callCategories();
  }

  void startEditing(CreateServiceCategory item) {
    isEditing.value = true;
    editingItem.value = item;
    nameController.text = item.name ?? '';
    isActive.value = (item.status ?? 0) == 1;
  }

  void resetForm() {
    nameController.clear();
    isActive.value = true;
    isEditing.value = false;
    editingItem.value = null;
  }

  Future<void> onAddOrUpdateCategoryPress() async {
    if (isEditing.value && editingItem.value != null) {
      await onEditPress(editingItem.value!.id ?? '');
    } else {
      await onAddCategoryPress();
    }
  }

  Future<void> onAddCategoryPress() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> serviceData = {
      'name': nameController.text,
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
    };

    try {
      await dioClient.postData<CreateServiceCategory>(
        '${Apis.baseUrl}${Endpoints.postServiceCategory}',
        serviceData,
        (json) => CreateServiceCategory.fromJson(json),
      );
      callCategories();
      CustomSnackbar.showSuccess('Success', 'Added Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> onEditPress(String id) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> staffData = {
      'name': nameController.text,
      'status': isActive.value ? 1 : 0,
      'salon_id': loginUser!.salonId,
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.postServiceCategory}/$id',
        staffData,
        (json) => json,
      );
      callCategories();
      CustomSnackbar.showSuccess('Success', 'Updated Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed: $e');
    }
  }

  Future<void> callCategories() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.postServiceCategoryGet}${loginUser!.salonId}',
        (json) => json,
      );

      if (response['data'] != null) {
        serviceList.value = (response['data'] as List)
            .map((e) => CreateServiceCategory.fromJson(e))
            .toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to fetch categories: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    final loginUser = await prefs.getUser();
    try {
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.postServiceCategory}/$id/?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      callCategories();
      CustomSnackbar.showSuccess('Success', 'Deleted Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete: $e');
    }
  }

}
