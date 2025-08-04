class DailyBookingModel {
  String? message;
  List<DailyBookingData>? data;

  DailyBookingModel({this.message, this.data});

  DailyBookingModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <DailyBookingData>[];
      json['data'].forEach((v) {
        data!.add(DailyBookingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyBookingData {
  String? date;
  int? appointmentsCount;
  int? servicesCount;
  num? serviceAmount;
  num? taxAmount;
  num? additionalCharges;
  num? tipsEarning;
  num? additionalDiscount;
  num? finalAmount;

  DailyBookingData(
      {this.date,
      this.appointmentsCount,
      this.servicesCount,
      this.serviceAmount,
      this.taxAmount,
      this.additionalCharges,
      this.tipsEarning,
      this.additionalDiscount,
      this.finalAmount});

  DailyBookingData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    appointmentsCount = json['appointmentsCount'];
    servicesCount = json['servicesCount'];
    serviceAmount = json['serviceAmount'];
    taxAmount = json['taxAmount'];
    tipsEarning = json['tipsEarning'];
    additionalCharges = json['additionalCharges'];
    additionalDiscount = json['additionalDiscount'];
    finalAmount = json['finalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['appointmentsCount'] = appointmentsCount;
    data['servicesCount'] = servicesCount;
    data['serviceAmount'] = serviceAmount;
    data['taxAmount'] = taxAmount;
    data['additionalCharges'] = additionalCharges;
    data['tipsEarning'] = tipsEarning;
    data['additionalDiscount'] = additionalDiscount;
    data['finalAmount'] = finalAmount;
    return data;
  }
}
