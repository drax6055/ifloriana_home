import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:flutter_template/network/network_const.dart';
import 'package:get/get.dart';
import '../../../wiget/custome_snackbar.dart';
import 'staff_payout_model.dart';
import 'package:intl/intl.dart';

class StatffearningReportcontroller extends GetxController {
  var payouts = <StaffPayout>[].obs;
  var isLoading = true.obs;
  var filterText = ''.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();

  List<StaffPayout> get filteredPayouts {
    var list = payouts.toList();
    if (filterText.value.isNotEmpty) {
      list = list
          .where((p) => p.staffName
              .toLowerCase()
              .contains(filterText.value.toLowerCase()))
          .toList();
    }
    if (startDate.value != null) {
      list = list.where((p) {
        final date = DateTime.tryParse(p.paymentDate);
        return date != null && !date.isBefore(startDate.value!);
      }).toList();
    }
    if (endDate.value != null) {
      list = list.where((p) {
        final date = DateTime.tryParse(p.paymentDate);
        final endOfDay = endDate.value!
            .add(Duration(days: 1))
            .subtract(Duration(microseconds: 1));
        return date != null && !date.isAfter(endOfDay);
      }).toList();
    }
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    getStaffEarningDataReport();
  }

  Future<void> getStaffEarningDataReport() async {
    try {
      isLoading.value = true;
      final loginUser = await prefs.getUser();
      final response = await dioClient.getData(
        '${Apis.baseUrl}/staff-payouts?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      if (response['success'] == true && response['data'] != null) {
        payouts.value = List<StaffPayout>.from(
          response['data'].map((x) => StaffPayout.fromJson(x)),
        );
      } else {
        payouts.clear();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', ': $e');
    } finally {
      isLoading.value = false;
    }
  }
}
