class ManagerLogin {
  String? token;
  String? message;
  Manager? manager;

  ManagerLogin({this.token, this.message, this.manager});

  ManagerLogin.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
    manager =
        json['manager'] != null ? new Manager.fromJson(json['manager']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['message'] = this.message;
    if (this.manager != null) {
      data['manager'] = this.manager!.toJson();
    }
    return data;
  }
}

class Manager {
  String? sId;
  String? fullName;
  String? email;
  String? contactNumber;
  String? gender;
  String? branchId;
  String? salonId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Manager(
      {this.sId,
      this.fullName,
      this.email,
      this.contactNumber,
      this.gender,
      this.branchId,
      this.salonId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Manager.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    email = json['email'];
    contactNumber = json['contact_number'];
    gender = json['gender'];
    branchId = json['branch_id'];
    salonId = json['salon_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['gender'] = this.gender;
    data['branch_id'] = this.branchId;
    data['salon_id'] = this.salonId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
