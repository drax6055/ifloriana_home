import 'package:get/get.dart';
import '../../../main.dart';
import '../../../network/model/coupon_model.dart';
import '../../../network/network_const.dart';
import '../../../wiget/custome_snackbar.dart';

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

class CouponsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getCoupons();
  }

  var couponList = <CouponModel>[].obs;

  Future<void> getCoupons() async {
    final loginUser = await prefs.getUser();
    try {
      final response = await dioClient.getData(
        '${Apis.baseUrl}${Endpoints.getCoupons}${loginUser!.salonId}',
        (json) => json,
      );
      print('${response.toString()}');
      final data = response['data'] as List;
      couponList.value = data.map((e) => CouponModel.fromJson(e)).toList();
    } catch (e) {
      print('${e.toString()}');
      CustomSnackbar.showError('Error', 'Failed to get data: $e');
    }
  }

  Future<void> deleteCoupon(String? couponId) async {
    final loginUser = await prefs.getUser();
    if (couponId == null) return;
    try {
      await dioClient.deleteData(
        '${Apis.baseUrl}${Endpoints.coupons}/$couponId?salon_id=${loginUser!.salonId}',
        (json) => json,
      );

      couponList.removeWhere((c) => c.id == couponId);
      CustomSnackbar.showSuccess('Deleted', 'Coupon deleted successfully');
    } catch (e) {
      CustomSnackbar.showError('Error', 'Failed to delete coupon: $e');
    }
  }

  // String formatTimeToString(TimeOfDay timeOfDay) {
  //   final now = DateTime.now();
  //   final time = DateTime(
  //       now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  //   return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  // }
}
