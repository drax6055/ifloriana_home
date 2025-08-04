import 'package:flutter/widgets.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/model/addService.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';

class Service {
  String? id;
  String? name;
  int? duration;
  int? price;
  int? status;
  String? description;
  String? categoryId;

  Service({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.status,
    this.description,
    this.categoryId,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    print('Parsing service JSON: $json');
    return Service(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      duration: json['service_duration'] is int
          ? json['service_duration']
          : int.tryParse(json['service_duration']?.toString() ?? '0'),
      price: json['regular_price'] is int
          ? json['regular_price']
          : int.tryParse(json['regular_price']?.toString() ?? '0'),
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '0'),
      description: json['description']?.toString(),
      categoryId: json['category_id']?.toString(),
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

class Addservicescontroller extends GetxController {
  var nameController = TextEditingController();
  var serviceDuration = TextEditingController();
  var regularPrice = TextEditingController();
  var descriptionController = TextEditingController();
  var isActive = true.obs;
  var selectedBranch = Rx<Category?>(null);
  var branchList = <Category>[].obs;
  var serviceList = <Service>[].obs;
  var isEditing = false.obs;
  var editingService = Rxn<Service>();

  @override
  void onInit() {
    super.onInit();
    print('Controller initialized');
    getCategorys();
    getAllServices();
  }

  void startEditing(Service service) {
    isEditing.value = true;
    editingService.value = service;
    nameController.text = service.name ?? '';
    serviceDuration.text = service.duration?.toString() ?? '';
    regularPrice.text = service.price?.toString() ?? '';
    descriptionController.text = service.description ?? '';
    isActive.value = service.status == 1;
    selectedBranch.value = branchList.firstWhereOrNull(
      (category) => category.id == service.categoryId,
    );
  }

  void resetForm() {
    nameController.clear();
    serviceDuration.clear();
    regularPrice.clear();
    descriptionController.clear();
    isActive.value = true;
    selectedBranch.value = null;
    isEditing.value = false;
    editingService.value = null;
  }

  Future<void> getCategorys() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData<Map<String, dynamic>>(
        '${Apis.baseUrl}${Endpoints.getServiceCategotyName}${loginUser!.salonId}',
        (json) => json as Map<String, dynamic>,
      );

      if (response['status'] == true && response['data'] != null) {
        final data = response['data'] as List;
        branchList.value = data.map((e) => Category.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> onServicePress() async {
    if (isEditing.value && editingService.value != null) {
      await updateService(editingService.value!.id!);
    } else {
      await addService();
    }
  }

  Future<void> addService() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> serviceData = {
      "image": null,
      "name": nameController.text,
      "service_duration": int.parse(serviceDuration.text),
      "regular_price": int.parse(regularPrice.text),
      "category_id": selectedBranch.value?.id,
      "description": descriptionController.text,
      "status": isActive.value ? 1 : 0,
      "salon_id": loginUser!.salonId
    };
    try {
      await dioClient.postData<AddService>(
        '${Apis.baseUrl}${Endpoints.getServices}',
        serviceData,
        (json) => AddService.fromJson(json),
      );
      getAllServices();
      Get.back();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'Service Added Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future<void> updateService(String id) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> serviceData = {
      "name": nameController.text,
      "service_duration": int.parse(serviceDuration.text),
      "regular_price": int.parse(regularPrice.text),
      "category_id": selectedBranch.value?.id,
      "description": descriptionController.text,
      "status": isActive.value ? 1 : 0,
      "salon_id": loginUser!.salonId
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.getServices}/$id?salon_id=${loginUser.salonId}',
        serviceData,
        (json) => json,
      );
      await getAllServices();
      Get.back();
      resetForm();
      CustomSnackbar.showSuccess('Success', 'Service Updated Successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to update service: $e');
    }
  }

  Future<void> getAllServices() async {
    final loginUser = await prefs.getUser();
    try {
      print('Fetching services for salon: ${loginUser!.salonId}');
      final response = await dioClient.getData<Map<String, dynamic>>(
        '${Apis.baseUrl}${Endpoints.getAllServices}${loginUser.salonId}',
        (json) => json as Map<String, dynamic>,
      );

      print('Response received: $response');

      if (response['data'] != null) {
        List<dynamic> servicesJson = response['data'];
        print('Services JSON: $servicesJson');

        final services = servicesJson.map((e) {
          print('Processing service: $e');
          return Service.fromJson(e);
        }).toList();

        print('Parsed services: ${services.length}');
        serviceList.value = services;
        print('Updated serviceList: ${serviceList.length}');
      } else {
        print('No services found or error in response');
        serviceList.clear();
        CustomSnackbar.showError(
            'Error', response['message'] ?? 'Failed to fetch services');
      }
    } catch (e) {
      print('Error in getAllServices: $e');
      serviceList.clear();
      CustomSnackbar.showError('Error', 'Failed to fetch services: $e');
    }
  }

  Future<void> deleteService(String id) async {
    final loginUser = await prefs.getUser();
    try {
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.getServices}/$id?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      await getAllServices();

      CustomSnackbar.showSuccess('Success', 'Service deleted successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete service: $e');
    }
  }
}
