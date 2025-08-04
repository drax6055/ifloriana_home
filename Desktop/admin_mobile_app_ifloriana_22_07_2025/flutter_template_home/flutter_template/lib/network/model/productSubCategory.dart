class ProductSubCategory {
  final String id;
  final List<Branch> branchId;
  final String image;
  final String name;
  final ProductCategory productCategoryId;
  final List<Brand> brandId;
  final int status;
  final String salonId;
  final String createdAt;
  final String updatedAt;

  ProductSubCategory({
    required this.id,
    required this.branchId,
    required this.image,
    required this.name,
    required this.productCategoryId,
    required this.brandId,
    required this.status,
    required this.salonId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: json['_id'] ?? '',
      branchId: (json['branch_id'] as List<dynamic>?)
              ?.map((branch) => Branch.fromJson(branch))
              .toList() ??
          [],
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      productCategoryId:
          ProductCategory.fromJson(json['product_category_id'] ?? {}),
      brandId: (json['brand_id'] as List<dynamic>?)
              ?.map((brand) => Brand.fromJson(brand))
              .toList() ??
          [],
      status: json['status'] ?? 0,
      salonId: json['salon_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Branch {
  final String id;
  final String name;
  final String salonId;
  final String category;
  final int status;
  final String contactEmail;
  final String contactNumber;
  final List<String> paymentMethod;
  final List<String> serviceId;
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
  final int ratingStar;
  final int totalReview;
  final String createdAt;
  final String updatedAt;

  Branch({
    required this.id,
    required this.name,
    required this.salonId,
    required this.category,
    required this.status,
    required this.contactEmail,
    required this.contactNumber,
    required this.paymentMethod,
    required this.serviceId,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      salonId: json['salon_id'] ?? '',
      category: json['category'] ?? '',
      status: json['status'] ?? 0,
      contactEmail: json['contact_email'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      paymentMethod: List<String>.from(json['payment_method'] ?? []),
      serviceId: List<String>.from(json['service_id'] ?? []),
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
      ratingStar: json['rating_star'] ?? 0,
      totalReview: json['total_review'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class ProductCategory {
  final String id;
  final List<String> branchId;
  final String image;
  final String name;
  final List<String> brandId;
  final int status;
  final String salonId;
  final String createdAt;
  final String updatedAt;

  ProductCategory({
    required this.id,
    required this.branchId,
    required this.image,
    required this.name,
    required this.brandId,
    required this.status,
    required this.salonId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['_id'] ?? '',
      branchId: List<String>.from(json['branch_id'] ?? []),
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      brandId: List<String>.from(json['brand_id'] ?? []),
      status: json['status'] ?? 0,
      salonId: json['salon_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class Brand {
  final String id;
  final List<String> branchId;
  final String image;
  final String name;
  final int status;
  final String salonId;
  final String createdAt;
  final String updatedAt;

  Brand({
    required this.id,
    required this.branchId,
    required this.image,
    required this.name,
    required this.status,
    required this.salonId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'] ?? '',
      branchId: List<String>.from(json['branch_id'] ?? []),
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      salonId: json['salon_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
