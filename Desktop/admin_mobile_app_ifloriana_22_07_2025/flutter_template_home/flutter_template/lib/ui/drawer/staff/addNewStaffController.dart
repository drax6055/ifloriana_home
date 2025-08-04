import 'package:flutter/material.dart';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:flutter_template/wiget/custome_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter_template/ui/drawer/staff/staffDetailsController.dart';

class Service {
  String? id;
  String? name;

  Service({this.id, this.name});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }
}

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

class Commition {
  final String? id;
  final String? name;

  Commition({this.id, this.name});

  factory Commition.fromJson(Map<String, dynamic> json) {
    return Commition(
      id: json['_id'],
      name: json['commission_name'],
    );
  }
}

class Addnewstaffcontroller extends GetxController {
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var shiftStarttimeController = TextEditingController();
  var shiftEndtimeController = TextEditingController();
  var selectedGender = "Male".obs;
  var specializationController = TextEditingController();
  var durationController = TextEditingController();
  var LunchStarttimeController = TextEditingController();

  var showPass = false.obs;
  var showPass2 = false.obs;

  RxList<Service> serviceList = <Service>[].obs;
  Rx<Service?> selectedService = Rx<Service?>(null);
  RxList<Service> selectedServices = <Service>[].obs;
  var branchList = <Branch>[].obs;
  var commitionList = <Commition>[].obs;
  var selectedBranch = Rx<Branch?>(null);
  var selectedCommitionId = Rx<Commition?>(null);

  var isEditMode = false.obs;
  String? editingStaffId;
  Data? _pendingStaffToPopulate;

  void toggleShowPass() {
    showPass.value = !showPass.value;
  }

  void toggleShowPass2() {
    showPass2.value = !showPass2.value;
  }

  var singleImage = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    getBranches();
    getCommition();
    getServices();
  }

  final List<String> dropdownItems = [
    'Male',
    'Female',
    'Other',
  ];

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

  Future<void> getServices() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getServiceNames}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      serviceList.value = data.map((e) => Service.fromJson(e)).toList();
      _tryPopulatePendingStaff();
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
      branchList.value = data.map((e) => Branch.fromJson(e)).toList();
      _tryPopulatePendingStaff();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> getCommition() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getcommisionForStaff}${loginUser!.salonId}',
        (json) => json,
      );

      final data = response['data'] as List;
      commitionList.value = data.map((e) => Commition.fromJson(e)).toList();
      _tryPopulatePendingStaff();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  void _tryPopulatePendingStaff() {
    if (_pendingStaffToPopulate != null &&
        branchList.isNotEmpty &&
        commitionList.isNotEmpty &&
        serviceList.isNotEmpty) {
      populateFromStaff(_pendingStaffToPopulate!);
      _pendingStaffToPopulate = null;
    }
  }

  void populateFromStaff(Data staff) {
    if (branchList.isEmpty || commitionList.isEmpty || serviceList.isEmpty) {
      _pendingStaffToPopulate = staff;
      return;
    }
    _pendingStaffToPopulate = null;
    fullnameController.text = staff.fullName ?? '';
    specializationController.text = staff.specialization ?? '';
    emailController.text = staff.email ?? '';
    phoneController.text = staff.phoneNumber ?? '';
    selectedGender.value = staff.gender?.capitalizeFirst ?? 'Male';
    shiftStarttimeController.text = staff.assignTime?.startShift ?? '';
    shiftEndtimeController.text = staff.assignTime?.endShift ?? '';
    durationController.text = staff.lunchTime?.duration?.toString() ?? '';
    LunchStarttimeController.text = staff.lunchTime?.timing ?? '';

    // Set selectedBranch (preselect like example)
    if (branchList.isNotEmpty) {
      final branch = branchList.firstWhere(
        (b) => b.id == staff.branchId?.sId,
        orElse: () => branchList.first,
      );
      selectedBranch.value = branch;
    } else {
      selectedBranch.value = null;
    }

    // Set selectedServices
    selectedServices.assignAll(
      serviceList
          .where((s) => staff.serviceId?.any((sid) => sid.sId == s.id) ?? false)
          .toList(),
    );

    if (commitionList.isNotEmpty) {
      final commiison = commitionList.firstWhere(
        (b) => b.id == staff.commissionId?.sId,
        orElse: () => commitionList.first,
      );
      selectedCommitionId.value = commiison;
    } else {
      selectedCommitionId.value = null;
    }
    // Set image
    singleImage.value = staff.image;
  }

  Future onUpdateStaffPress() async {
    final Map<String, dynamic> updateStaffData = {
      'full_name': fullnameController.text,
      'email': emailController.text,
      'phone_number': phoneController.text,
      'gender': selectedGender.value.toLowerCase(),
      'branch_id': selectedBranch.value?.id,
      'service_id': selectedServices.map((s) => s.id).toList(),
      'status': 1,
      'specialization': specializationController.text,
      'assigned_commission_id': selectedCommitionId.value?.id,
      'salon_id': (await prefs.getUser())?.salonId,
      'assign_time': {
        'start_shift': shiftStarttimeController.text,
        'end_shift': shiftEndtimeController.text,
      },
      'lunch_time': {
        'duration': int.tryParse(durationController.text) ?? 0,
        'timing': LunchStarttimeController.text,
      },
    };
    if (singleImage.value != null) {
      updateStaffData['image'] = singleImage.value;
    }
    try {
      await dioClient.putData(
        '${Apis.baseUrl}${Endpoints.postStaffDetails}/$editingStaffId',
        updateStaffData,
        (json) => json,
      );
      CustomSnackbar.showSuccess('Success', 'Staff updated successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', e.toString());
    }
  }

  Future onAddStaffPress() async {
    Map<String, dynamic> staffData = {
      'full_name': fullnameController.text,
      'email': emailController.text,
      'phone_number': phoneController.text,
      'gender': selectedGender.value.toLowerCase(),
      'branch_id': selectedBranch.value?.id,
      'service_id': selectedServices.map((s) => s.id).toList(),
      'status': 1,
      'assigned_commission_id': selectedCommitionId.value!.id,
      'salon_id': (await prefs.getUser())?.salonId,
      'image': null,
      'specialization': specializationController.text,
      'assign_time': {
        'start_shift': shiftStarttimeController.text,
        'end_shift': shiftEndtimeController.text,
      },
      'lunch_time': {
        'duration': int.tryParse(durationController.text) ?? 0,
        'timing': LunchStarttimeController.text,
      },
    };
    try {
      await dioClient.postData(
        '${Apis.baseUrl}${Endpoints.postStaffDetails}',
        staffData,
        (json) => json,
      );
      print("===> ${staffData.toString()}");
      CustomSnackbar.showSuccess('Success', 'Staff added successfully');
    } catch (e) {
      print('==> Add Staff Error: $e');
      CustomSnackbar.showError('Error', e.toString());
    }
  }
}
