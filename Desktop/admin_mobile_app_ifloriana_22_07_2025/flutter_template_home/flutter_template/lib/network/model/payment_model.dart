class PaymentModel {
  final String? message;
  final List<PaymentData>? data;

  PaymentModel({this.message, this.data});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      message: json['message'],
      data: json['data'] != null
          ? List<PaymentData>.from(
              json['data'].map((x) => PaymentData.fromJson(x)))
          : null,
    );
  }
}

class PaymentData {
  final num? additionalCharges;
  final String? id;
  final String? appointmentId;
  final num? serviceAmount;
  final num? productAmount;
  final num? packageDiscount;
  final String? couponId;
  final num? couponDiscount;
  final String? additionalDiscountType;
  final String? taxId;
  final num? taxAmount;
  final num? tips;
  final num? subTotal;
  final num? finalTotal;
  final String? paymentMethod;
  final SalonId? salonId;
  final String? createdAt;
  final String? updatedAt;
  final num? v;
  final num? additionalDiscount;
  final String? invoicePdfUrl;
  final String? invoiceFileName;
  final num? serviceCount;
  final List<StaffTip>? staffTips;

  PaymentData({
    this.additionalCharges,
    this.id,
    this.appointmentId,
    this.serviceAmount,
    this.productAmount,
    this.packageDiscount,
    this.couponId,
    this.couponDiscount,
    this.additionalDiscountType,
    this.taxId,
    this.taxAmount,
    this.tips,
    this.subTotal,
    this.finalTotal,
    this.paymentMethod,
    this.salonId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.additionalDiscount,
    this.invoicePdfUrl,
    this.invoiceFileName,
    this.serviceCount,
    this.staffTips,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      additionalCharges: json['additional_charges'],
      id: json['_id'],
      appointmentId: json['appointment_id'],
      serviceAmount: json['service_amount'],
      productAmount: json['product_amount'],
      packageDiscount: json['package_discount'],
      couponId: json['coupon_id'],
      couponDiscount: json['coupon_discount'],
      additionalDiscountType: json['additional_discount_type'],
      taxId: json['tax_id'],
      taxAmount: json['tax_amount'],
      tips: json['tips'],
      subTotal: json['sub_total'],
      finalTotal: json['final_total'],
      paymentMethod: json['payment_method'],
      salonId:
          json['salon_id'] != null ? SalonId.fromJson(json['salon_id']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      additionalDiscount: json['additional_discount'],
      invoicePdfUrl: json['invoice_pdf_url'],
      invoiceFileName: json['invoice_file_name'],
      serviceCount: json['service_count'],
      staffTips: json['staff_tips'] != null
          ? List<StaffTip>.from(
              json['staff_tips'].map((x) => StaffTip.fromJson(x)))
          : null,
    );
  }

  String get formattedDate {
    if (createdAt == null) return '';
    try {
      final date = DateTime.parse(createdAt!);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return createdAt!;
    }
  }

  String get invoiceId {
    if (id == null) return '';
    return 'IFL-${DateTime.parse(createdAt ?? DateTime.now().toIso8601String()).year}${DateTime.parse(createdAt ?? DateTime.now().toIso8601String()).month.toString().padLeft(2, '0')}-${id!.substring(id!.length - 2)}';
  }
}

class SalonId {
  final String? id;

  SalonId({this.id});

  factory SalonId.fromJson(Map<String, dynamic> json) {
    return SalonId(id: json['_id']);
  }
}

class StaffTip {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final num? tip;

  StaffTip({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.tip,
  });

  factory StaffTip.fromJson(Map<String, dynamic> json) {
    return StaffTip(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      tip: json['tip'],
    );
  }
}
