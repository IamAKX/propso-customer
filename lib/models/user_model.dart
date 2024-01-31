import 'dart:convert';

class UserModel {
  int? id;
  String? fullName;
  String? mobileNo;
  String? email;
  String? status;
  String? aadharFront;
  String? aadharBack;
  String? pan;
  String? createdDate;
  String? updatedDate;
  String? userType;
  String? vpa;
  String? image;
  String? referralCode;
  bool? isKycVerified;
  UserModel({
    this.id,
    this.fullName,
    this.mobileNo,
    this.email,
    this.status,
    this.aadharFront,
    this.aadharBack,
    this.pan,
    this.createdDate,
    this.updatedDate,
    this.userType,
    this.vpa,
    this.image,
    this.referralCode,
    this.isKycVerified,
  });

  UserModel copyWith({
    int? id,
    String? fullName,
    String? mobileNo,
    String? email,
    String? status,
    String? aadharFront,
    String? aadharBack,
    String? pan,
    String? createdDate,
    String? updatedDate,
    String? userType,
    String? vpa,
    String? image,
    String? referralCode,
    bool? isKycVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNo: mobileNo ?? this.mobileNo,
      email: email ?? this.email,
      status: status ?? this.status,
      aadharFront: aadharFront ?? this.aadharFront,
      aadharBack: aadharBack ?? this.aadharBack,
      pan: pan ?? this.pan,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      userType: userType ?? this.userType,
      vpa: vpa ?? this.vpa,
      image: image ?? this.image,
      referralCode: referralCode ?? this.referralCode,
      isKycVerified: isKycVerified ?? this.isKycVerified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'mobileNo': mobileNo,
      'email': email,
      'status': status,
      'aadharFront': aadharFront,
      'aadharBack': aadharBack,
      'pan': pan,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'userType': userType,
      'vpa': vpa,
      'image': image,
      'referralCode': referralCode,
      'isKycVerified': isKycVerified,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt(),
      fullName: map['fullName'],
      mobileNo: map['mobileNo'],
      email: map['email'],
      status: map['status'],
      aadharFront: map['aadharFront'],
      aadharBack: map['aadharBack'],
      pan: map['pan'],
      createdDate: map['createdDate'],
      updatedDate: map['updatedDate'],
      userType: map['userType'],
      vpa: map['vpa'],
      image: map['image'],
      referralCode: map['referralCode'],
      isKycVerified: map['isKycVerified'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, mobileNo: $mobileNo, email: $email, status: $status, aadharFront: $aadharFront, aadharBack: $aadharBack, pan: $pan, createdDate: $createdDate, updatedDate: $updatedDate, userType: $userType, vpa: $vpa, image: $image, referralCode: $referralCode, isKycVerified: $isKycVerified)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.fullName == fullName &&
      other.mobileNo == mobileNo &&
      other.email == email &&
      other.status == status &&
      other.aadharFront == aadharFront &&
      other.aadharBack == aadharBack &&
      other.pan == pan &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate &&
      other.userType == userType &&
      other.vpa == vpa &&
      other.image == image &&
      other.referralCode == referralCode &&
      other.isKycVerified == isKycVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      fullName.hashCode ^
      mobileNo.hashCode ^
      email.hashCode ^
      status.hashCode ^
      aadharFront.hashCode ^
      aadharBack.hashCode ^
      pan.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode ^
      userType.hashCode ^
      vpa.hashCode ^
      image.hashCode ^
      referralCode.hashCode ^
      isKycVerified.hashCode;
  }
}
