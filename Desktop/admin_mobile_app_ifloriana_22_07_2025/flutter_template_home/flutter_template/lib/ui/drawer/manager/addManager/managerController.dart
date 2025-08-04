import 'package:flutter/widgets.dart';
import 'package:flutter_template/network/model/AddManager.dart';
import 'package:get/get.dart';
import '../../../../main.dart';
import '../../../../network/network_const.dart';
import '../../../../wiget/custome_snackbar.dart';
import '../getManager/getmanagerController.dart';

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

class Managercontroller extends GetxController {
  var fullNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var contactNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var selectedGender = "Male".obs;
  var selectedBranch = Rx<Branch?>(null);
  var branchList = <Branch>[].obs;
  var showPassword = false.obs;
  var showConfirmPassword = false.obs;
  @override
  void onInit() {
    super.onInit();
    getBranches();
  }

  final List<String> dropdownItems = [
    'Male',
    'Female',
    'Other',
  ];
  void toggleShowPassword() {
    showPassword.value = !showPassword.value;
  }

  void toggleShowConfirmPass() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  Future onManagerAdd() async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> managerData = {
      "image": null,
      "full_name": fullNameController.text,
      // "last_name": lastNameController.text,
      "email": emailController.text,
      "contact_number": contactNumberController.text,
      "password": passwordController.text,
      "confirm_password": confirmPasswordController.text,
      'gender': selectedGender.value.toLowerCase(),
      "salon_id": loginUser!.salonId,
      'branch_id': selectedBranch.value?.id,
    };

    try {
      await dioClient.postData<AddManaget>(
        '${Apis.baseUrl}${Endpoints.addManager}',
        managerData,
        (json) => AddManaget.fromJson(json),
      );
       final getManagerController = Get.find<Getmanagercontroller>();
      await getManagerController.getManagers();
      CustomSnackbar.showSuccess('Succcess', 'Manager Added');
    } catch (e) {
      print('==> here Error: $e');
      CustomSnackbar.showError('Error', e.toString());
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
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> updateManager(String id) async {
    final loginUser = await prefs.getUser();
    Map<String, dynamic> managerData = {
      "full_name": fullNameController.text,
      // "last_name": lastNameController.text,
      "email": emailController.text,
      "contact_number": contactNumberController.text,
      'gender': selectedGender.value.toLowerCase(),
      "salon_id": loginUser!.salonId,
      'branch_id': selectedBranch.value?.id,
    };
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.addManager}/$id',
        managerData,
        (json) => json,
      );
          final getManagerController = Get.find<Getmanagercontroller>();
      await getManagerController.getManagers();
      CustomSnackbar.showSuccess('Success', 'Manager updated successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to update manager: $e');
    }
  }
}
