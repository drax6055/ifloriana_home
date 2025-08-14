import 'dart:async';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';

import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

class Appointment {
  final String appointmentId;
  final String date;
  final String time;
  final String clientName;
  final String? clientImage;
  final String? clientPhone;
  final int amount;
  final String staffName;
  final String? staffImage;
  final String serviceName;
  final String? membership;
  final String? package;
  final String status;
  final String paymentStatus;
  final double? branchMembershipDiscount;
  final String? branchMembershipDiscountType;

  Appointment({
    required this.appointmentId,
    required this.date,
    required this.time,
    required this.clientName,
    this.clientImage,
    this.clientPhone,
    required this.amount,
    required this.staffName,
    this.staffImage,
    required this.serviceName,
    this.membership,
    this.package,
    required this.status,
    required this.paymentStatus,
    this.branchMembershipDiscount,
    this.branchMembershipDiscountType,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] ?? {};
    final services = (json['services'] as List?) ?? [];
    final firstService = services.isNotEmpty ? services[0] : {};
    final service = firstService['service'] ?? {};
    final staff = firstService['staff'] ?? {};
    final branchMembership = customer['branch_membership'];

    // Helper function to safely convert dynamic to string
    String toString(dynamic value) {
      if (value == null) return '';
      if (value is String) return value;
      if (value is Map) {
        // Handle image object - construct URL or return empty string
        if (value.containsKey('data') && value.containsKey('contentType')) {
          // This is an image object, you might want to construct a URL here
          // For now, return empty string to avoid errors
          return '';
        }
        return value.toString();
      }
      return value.toString();
    }

    // Helper function to safely convert dynamic to int
    int toInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Helper function to normalize status values
    String _normalizeStatus(String status) {
      final normalized = status.toLowerCase().trim();
      if (normalized == 'check-in' || normalized == 'check in') {
        return 'check in';
      } else if (normalized == 'check-out' || normalized == 'check out') {
        return 'check out';
      }
      return normalized;
    }

    return Appointment(
      appointmentId: toString(json['appointment_id']),
      date: toString(json['appointment_date']).split('T')[0],
      time: toString(json['appointment_time']),
      clientName: toString(customer['full_name']),
      clientImage:
          customer['image'] is Map ? null : toString(customer['image']),
      clientPhone: toString(customer['phone_number']),
      amount: toInt(json['total_payment']),
      staffName: toString(staff['full_name']),
      staffImage: staff['image'] is Map ? null : toString(staff['image']),
      serviceName: toString(service['name']),
      membership: customer['branch_membership'] != null ? 'Yes' : '-',
      package: (customer['branch_package'] != null &&
              (customer['branch_package'] is List
                  ? customer['branch_package'].isNotEmpty
                  : true))
          ? 'Yes'
          : '-',
      status: _normalizeStatus(toString(json['status'])),
      paymentStatus: toString(json['payment_status']),
      branchMembershipDiscount: branchMembership != null
          ? (branchMembership['discount'] is int
              ? (branchMembership['discount'] as int).toDouble()
              : (branchMembership['discount'] ?? 0).toDouble())
          : null,
      branchMembershipDiscountType: branchMembership != null
          ? toString(branchMembership['discount_type'])
          : null,
    );
  }
}

class TaxModel {
  final String id;
  final String title;
  final double value;

  TaxModel({required this.id, required this.title, required this.value});

  factory TaxModel.fromJson(Map<String, dynamic> json) {
    return TaxModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      value: (json['value'] is int)
          ? (json['value'] as int).toDouble()
          : (json['value'] ?? 0).toDouble(),
    );
  }
}

class CouponModel {
  final String id;
  final String code;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String discountType;
  final double discountAmount;
  final int status;

  CouponModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.discountType,
    required this.discountAmount,
    required this.status,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'] ?? '',
      code: json['coupon_code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      discountType: json['discount_type'] ?? '',
      discountAmount: (json['discount_amount'] is int)
          ? (json['discount_amount'] as int).toDouble()
          : (json['discount_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 0,
    );
  }
}

class PaymentSummaryState {
  Rx<TaxModel?> selectedTax = Rx<TaxModel?>(null);
  RxString tips = '0'.obs;
  RxString paymentMethod = ''.obs;
  RxString couponCode = ''.obs;
  Rx<CouponModel?> appliedCoupon = Rx<CouponModel?>(null);
  RxBool addAdditionalDiscount = false.obs;
  RxString discountType = 'percentage'.obs;
  RxString discountValue = '0'.obs;
  RxDouble grandTotal = 0.0.obs;
}

class AppointmentController extends GetxController {
  var appointments = <Appointment>[].obs;
  var isLoading = false.obs;
  var taxes = <TaxModel>[].obs;
  var coupons = <CouponModel>[].obs;
  var paymentSummaryState = PaymentSummaryState();

  @override
  void onInit() {
    super.onInit();
    getTax();
    getCoupons();
    getAppointment();
  }

  Future<void> getAppointment() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}/appointments?salon_id=${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null && response['success'] == true) {
        final List data = response['data'] ?? [];
        appointments.value = data.map((e) => Appointment.fromJson(e)).toList();
      }
      print("${Apis.baseUrl}/appointments?salon_id=${loginUser.salonId}");
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTax() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getTex}${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null && response['data'] != null) {
        final List data = response['data'] ?? [];
        taxes.value = data.map((e) => TaxModel.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCoupons() async {
    final loginUser = await prefs.getUser();
    isLoading.value = true;
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getCoupons}${loginUser!.salonId}',
        (json) => json,
      );
      if (response != null && response['data'] != null) {
        final List data = response['data'] ?? [];
        coupons.value = data.map((e) => CouponModel.fromJson(e)).toList();
      }
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void applyCoupon(String code) {
    final now = DateTime.now();
    final coupon = coupons.firstWhereOrNull((c) {
      final start = DateTime.tryParse(c.startDate);
      final end = DateTime.tryParse(c.endDate);
      return c.code.toLowerCase() == code.toLowerCase() &&
          c.status == 1 &&
          start != null &&
          end != null &&
          now.isAfter(start) &&
          now.isBefore(end.add(const Duration(days: 1)));
    });
    if (coupon != null) {
      paymentSummaryState.appliedCoupon.value = coupon;
      CustomSnackbar.showSuccess('Coupon Applied', coupon.code);
    } else {
      paymentSummaryState.appliedCoupon.value = null;
      CustomSnackbar.showError(
          'Invalid Coupon', 'Coupon is not active or does not exist');
    }
  }

  // Add this function to calculate the grand total
  void calculateGrandTotal({
    required double servicePrice,
    double memberDiscount = 0.0,
    double taxValue = 0.0,
    double tip = 0.0,
    double couponDiscount = 0.0,
    double additionalDiscount = 0.0,
    String discountType = 'percentage',
  }) {
    double total = servicePrice - memberDiscount;
    total -= couponDiscount;
    // Apply additional discount if any
    if (additionalDiscount > 0) {
      if (discountType == 'percentage') {
        total -= (total * additionalDiscount / 100);
      } else {
        total -= additionalDiscount;
      }
    }
    double totalWithTax = total + taxValue;
    double grandTotal = totalWithTax + tip;
    paymentSummaryState.grandTotal.value = grandTotal < 0 ? 0 : grandTotal;
  }

  // Cancel appointment method
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final response = await dioClient.dio.put(
        '${Apis.baseUrl}/appointments/$appointmentId',
        data: {
          'status': 'cancelled',
        },
      );
      CustomSnackbar.showSuccess(
          'Success', 'Appointment cancelled successfully');
      await getAppointment();
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to cancel appointment: $e');
    }
  }
}
