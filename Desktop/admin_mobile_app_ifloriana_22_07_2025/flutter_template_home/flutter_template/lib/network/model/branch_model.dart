class BranchModel {
  final String id;
  final String name;
  final String category;
  final int status;
  final String contactEmail;
  final String contactNumber;
  final List<String> paymentMethod;
  final List<ServiceModel> services;
  final String address;
  final String landmark;
  final String country;
  final String state;
  final String city;
  final String postalCode;
  final double latitude;
  final double longitude;
  final String description;
  final String image;
  final double ratingStar;
  final int totalReview;
  final int staffCount;

  BranchModel({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.contactEmail,
    required this.contactNumber,
    required this.paymentMethod,
    required this.services,
    required this.address,
    required this.landmark,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.image,
    required this.ratingStar,
    required this.totalReview,
    required this.staffCount,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 0,
      contactEmail: json['contact_email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      paymentMethod: List<String>.from(json['payment_method'] ?? []),
      services: (json['service_id'] as List?)
              ?.map((service) => ServiceModel.fromJson(service))
              .toList() ??
          [],
      address: json['address'] ?? '',
      landmark: json['landmark'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      ratingStar: (json['rating_star'] ?? 0.0).toDouble(),
      totalReview: json['total_review'] ?? 0,
      staffCount: json['staff_count'] ?? 0,
    );
  }
}

class ServiceModel {
  final String id;
  final String name;
  final int serviceDuration;
  final double regularPrice;
  final String categoryId;
  final String description;
  final int status;
  final String salonId;
  final String image;

  ServiceModel({
    required this.id,
    required this.name,
    required this.serviceDuration,
    required this.regularPrice,
    required this.categoryId,
    required this.description,
    required this.status,
    required this.salonId,
    required this.image,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      serviceDuration: json['service_duration'] ?? 0,
      regularPrice: (json['regular_price'] ?? 0.0).toDouble(),
      categoryId: json['category_id'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 0,
      salonId: json['salon_id'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
