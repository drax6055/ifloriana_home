import 'package:flutter/material.dart';
import 'package:flutter_template/network/model/addModel.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../main.dart';

class Service {
  String? id;
  String? name;

  Service({this.id, this.name});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }
}

class Postbranchescontroller extends GetxController {
  @override
  void onInit() async {
    super.onInit();
  
    getServices();
    final locationDetails = await getUserLocationDetails();
    landmarkController.text = locationDetails['landmark'] ?? '';
    countryController.text = locationDetails['country'] ?? '';
    stateController.text = locationDetails['state'] ?? '';
    cityController.text = locationDetails['city'] ?? '';
    postalCodeController.text = locationDetails['postal_code'] ?? '';
    print(locationDetails); // You will get landmark, country, etc.
  }

  var nameController = TextEditingController();
  var contactEmailController = TextEditingController();
  var contactNumberController = TextEditingController();
  var landmarkController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var postalCodeController = TextEditingController();
  var discriptionController = TextEditingController();
  var addressController = TextEditingController();
  var selectedCategory = "Male".obs;
  var isActive = true.obs;
  RxList<Service> selectedServices = <Service>[].obs;
  RxList<Service> serviceList = <Service>[].obs;
  RxString locationText = "Press the button to get location".obs;
  final RxList<String> selectedPaymentMethod = <String>[].obs;
  var pincodeController = TextEditingController();

  // var latController = TextEditingController();
  // var lngController = TextEditingController();

  final List<String> dropdownItemSelectedCategory = [
    'Male',
    'Female',
    'Unisex',
  ];

  final List<String> dropdownItemPaymentMethod = [
    'Cash',
    'UPI',
  ];

  var isLoading = false.obs;
  var latitude = ''.obs;
  var longitude = ''.obs;

  var country = ''.obs;
  var state = ''.obs;
  var district = ''.obs;
  var block = ''.obs;
  var error = ''.obs;

  var landmark = ''.obs;
  var city = ''.obs;
  var postalCode = ''.obs;

  Future<void> getServices() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getServiceNames}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      serviceList.value = data.map((e) => Service.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> fetchLocation() async {
    isLoading.value = true;
    CustomSnackbar.showSuccess('Location Fetching:',
        "Wait for a while, we're fetching your location.");
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      isLoading.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        isLoading.value = false;
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
    isLoading.value = false;
  }

  Future<Map<String, String>> getUserLocationDetails() async {
    // 1. Check location permission
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // 2. Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // 3. Reverse geocode the coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;

      return {
        "landmark": placemark.street ?? "",
        "country": placemark.country ?? "",
        "state": placemark.administrativeArea ?? "",
        "city": placemark.locality ?? placemark.subAdministrativeArea ?? "",
        "postal_code": placemark.postalCode ?? "",
      };
    } else {
      throw Exception('Failed to get placemark data');
    }
  }

  Future onBranchAdd() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> branchData = {
      "name": nameController.text,
      "salon_id": loginUser!.salonId,
      'category': selectedCategory.value.toLowerCase(),
      'status': isActive.value ? 1 : 0,
      "contact_email": contactEmailController.text,
      "contact_number": contactNumberController.text,
      "payment_method":
          selectedPaymentMethod.map((e) => e.toLowerCase()).toList(),
      'service_id': selectedServices.map((s) => s.id).toList(),
      "landmark": landmarkController.text,
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "postal_code": postalCodeController.text,
      // "latitude": latitude.value,
      // "longitude": longitude.value,
      "description": discriptionController.text,
      "image": null,
      "address": addressController.text
    };
    print("===> $branchData");
    try {
      await dioClient.postData<AddBranch>(
        '${Apis.baseUrl}${Endpoints.postBranchs}',
        branchData,
        (json) => AddBranch.fromJson(json),
      );
      CustomSnackbar.showSuccess('Success', 'Branch added successfully');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
