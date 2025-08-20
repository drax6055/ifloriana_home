import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/main.dart';
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
  String? categoryName;
  String? image_url;

  Service({
    this.id,
    this.name,
    this.duration,
    this.price,
    this.status,
    this.description,
    this.categoryId,
    this.categoryName,
    this.image_url,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
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
      categoryId: json['category_id'] is Map
          ? (json['category_id']['_id']?.toString())
          : json['category_id']?.toString(),
      categoryName: json['category_id'] is Map
          ? (json['category_id']['name']?.toString())
          : null,
      image_url: json['image_url']?.toString(),
    );
  }
}

class ManagerServicecontroller extends GetxController {
  var isActive = true.obs;
  var serviceList = <Service>[].obs;
  var filteredServiceList = <Service>[].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  var selectedCategoryId = RxnString();
  var categoryOptions = <Map<String, String>>[].obs; // {'id': ..., 'name': ...}
  var editingService = Rxn<Service>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAllServices();
  }

  Future<void> getAllServices() async {
    final manager = await prefs.getManagerUser();
    try {
      final response = await dioClient.getData<Map<String, dynamic>>(
        '${Apis.baseUrl}${Endpoints.getAllServices}${manager?.manager?.salonId}',
        (json) => json as Map<String, dynamic>,
      );

      if (response['data'] != null) {
        List<dynamic> servicesJson = response['data'];

        final services = servicesJson.map((e) {
          return Service.fromJson(e);
        }).toList();

        serviceList.value = services;
        _rebuildCategoryOptions();
        _applyFilters();
      } else {
        serviceList.clear();
        filteredServiceList.clear();
        CustomSnackbar.showError(
            'Error', response['message'] ?? 'Failed to fetch services');
      }
    } catch (e) {
      serviceList.clear();
      filteredServiceList.clear();
      CustomSnackbar.showError('Error', 'Failed to fetch services: $e');
    }
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      setSearchQuery('');
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setCategoryFilter(String? categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }

  void clearFilters() {
    selectedCategoryId.value = null;
    setSearchQuery('');
  }

  void _applyFilters() {
    var list = List<Service>.from(serviceList);

    final categoryId = selectedCategoryId.value;
    if (categoryId != null && categoryId.isNotEmpty) {
      list = list.where((s) => (s.categoryId ?? '') == categoryId).toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((s) => (s.name ?? '').toLowerCase().contains(query))
          .toList();
    }

    filteredServiceList.value = list;
  }

  void _rebuildCategoryOptions() {
    final Map<String, String> idToName = {};
    for (final s in serviceList) {
      if ((s.categoryId ?? '').isNotEmpty) {
        idToName[s.categoryId!] = s.categoryName ?? 'Unknown';
      }
    }
    final options = idToName.entries
        .map((e) => {'id': e.key, 'name': e.value})
        .toList()
      ..sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
    categoryOptions.value = options;
  }
}
