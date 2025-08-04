import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_template/network/model/udpateSalonModel.dart';
import 'package:flutter_template/route/app_route.dart';
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';
import 'package:flutter_template/ui/drawer/drawer_controller.dart';

class UdpatesalonController extends GetxController {
  var fullnameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var descriptionController = TextEditingController();
  var opentimeController = TextEditingController();
  var closetimeController = TextEditingController();
  var selectedcategory = "UNISEX".obs;

  var singleImage = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    getSalonDetails();
  }

  void getSalonDetails() async {
    final salonDetails = await prefs.getSalonDetails();
    if (salonDetails != null) {
      fullnameController.text = salonDetails.data!.name ?? '';
      addressController.text = salonDetails.data!.address ?? '';
      emailController.text = salonDetails.data!.contactEmail ?? '';
      phoneController.text = salonDetails.data!.contactNumber ?? '';
      descriptionController.text = salonDetails.data!.description ?? '';
      opentimeController.text = salonDetails.data!.openingTime ?? '';
      closetimeController.text = salonDetails.data!.closingTime ?? '';
      selectedcategory.value =
          salonDetails.data!.category?.toUpperCase() ?? 'UNISEX';
      if (salonDetails.data!.image != null &&
          salonDetails.data!.image!.isNotEmpty) {
        final imagePath = salonDetails.data!.image!;

        if (imagePath.startsWith('http')) {
          singleImage.value = imagePath;
        } else {
          try {
            final file = File(imagePath);
            if (await file.exists()) {
              singleImage.value = file;
            } else {
              singleImage.value = null;
            }
          } catch (e) {
            CustomSnackbar.showError("Error", "Failed to load image: $e");
          }
        }
      }
    }
  }

  final List<String> dropdownItems = [
    'MALE',
    'FEMALE',
    'UNISEX',
  ];

  var currentStep = 0.obs;

  void goToStep(int step) {
    currentStep.value = step;
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // String formatTimeToString(TimeOfDay timeOfDay) {
  //   final now = DateTime.now();
  //   final time = DateTime(
  //       now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  //   return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  // }

  Future<void> onupdateClick() async {
    final loginUser = await prefs.getUser();
    File? imageFile;
    String? imagePath;

    if (singleImage.value != null && singleImage.value.toString().isNotEmpty) {
      if (singleImage.value is File) {
        imageFile = singleImage.value as File;
        imagePath = imageFile.path;
        if (!imageFile.existsSync()) {
          CustomSnackbar.showError("Error", "Image file does not exist");
          return;
        }
      } else if (singleImage.value is String &&
          (singleImage.value as String).startsWith('http')) {
        imageFile = null;
        imagePath = singleImage.value as String;
      } else {
        imagePath = singleImage.value.toString();
        if (imagePath.isNotEmpty) {
          imageFile = File(imagePath);
          if (!imageFile.existsSync()) {
            CustomSnackbar.showError("Error", "Image file does not exist");
            return;
          }
        }
      }
    }
    Map<String, dynamic> salon_post_details = {
      'name': fullnameController.text,
      'description': descriptionController.text,
      'address': addressController.text,
      'contact_number': phoneController.text,
      'contact_email': emailController.text,
      'opening_time': opentimeController.text,
      'closing_time': closetimeController.text,
      'category': selectedcategory.value.toLowerCase(),
      'status': 1,
      'package_id': loginUser!.packageId,
      'signup_id': loginUser.adminId,
      if (imageFile != null)
        'image': await dio.MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split(Platform.pathSeparator).last,
        ),
    };

    try {
      final formData = dio.FormData.fromMap(salon_post_details);

      final response = await dioClient.putFormData<UpdateSalonModel>(
        '${Apis.baseUrl}${Endpoints.update_salon}${loginUser.salonId}',
        formData,
        (json) => UpdateSalonModel.fromJson(json),
      );
      await prefs.setSalonDetails(response);
      final drawerController = Get.find<DrawermenuController>();
      await drawerController.getUserDetails();
      CustomSnackbar.showSuccess("Done", "Salon details updated successfully");
      Get.offAllNamed(Routes.drawerScreen);
    } catch (e) {
      CustomSnackbar.showError("Error", "Failed to update salon details: $e");
    }
  }
}
