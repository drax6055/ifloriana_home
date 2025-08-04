class CouponModel {
  final String? id;
  final String? name;
  final String? code;
  final String? description;
  final String? type;
  final String? discountType;
  final int? discountAmount;
  final int? useLimit;
  final int? status;
  final String? startDate;
  final String? endDate;
  final List<String>? branchIds;

  CouponModel({
    this.id,
    this.name,
    this.code,
    this.description,
    this.type,
    this.discountType,
    this.discountAmount,
    this.useLimit,
    this.status,
    this.startDate,
    this.endDate,
    this.branchIds,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely extract string values
    String? getString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is Map) return value['_id']?.toString();
      return value.toString();
    }

    // Helper function to safely extract int values
    int? getInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    // Helper function to safely extract list of strings
    List<String>? getStringList(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value
            .map((item) {
              if (item is String) return item;
              if (item is Map) return item['_id']?.toString();
              return item.toString();
            })
            .where((item) => item != null)
            .cast<String>()
            .toList();
      }
      return null;
    }

    return CouponModel(
      id: getString(json['_id']),
      name: getString(json['name']),
      code: getString(json['coupon_code']),
      description: getString(json['description']),
      type: getString(json['coupon_type']),
      discountType: getString(json['discount_type']),
      discountAmount: getInt(json['discount_amount']),
      useLimit: getInt(json['use_limit']),
      status: getInt(json['status']),
      startDate: getString(json['start_date']),
      endDate: getString(json['end_date']),
      branchIds: getStringList(json['branch_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'coupon_code': code,
      'description': description,
      'coupon_type': type,
      'discount_type': discountType,
      'discount_amount': discountAmount,
      'use_limit': useLimit,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'branch_id': branchIds,
    };
  }
}
