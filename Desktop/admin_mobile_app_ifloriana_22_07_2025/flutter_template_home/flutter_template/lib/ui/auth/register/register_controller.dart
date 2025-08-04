import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  var fullnameController = TextEditingController();
  var salonNameController = TextEditingController();
  var addressController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  var currentStep = 0.obs;

  void goToStep(int step) {
    currentStep.value = step;
  }


  void nextStep() {
    if (currentStep.value < 1) {
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
}
