import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:propertycp_customer/models/lead_comment_model.dart';
import 'package:propertycp_customer/models/user_model.dart';


class LeadsModelWithUser {
  int? id;
  String? propertyType;
  String? mobileNo;
  String? fullName;
  String? status;
  List<LeadCommentModel>? leadCommentModel;
  String? createdDate;
  String? updatedDate;
  int? createdById;
  UserModel? createdBy;
  LeadsModelWithUser({
    this.id,
    this.propertyType,
    this.mobileNo,
    this.fullName,
    this.status,
    this.leadCommentModel,
    this.createdDate,
    this.updatedDate,
    this.createdById,
    this.createdBy,
  });

  LeadsModelWithUser copyWith({
    int? id,
    String? propertyType,
    String? mobileNo,
    String? fullName,
    String? status,
    List<LeadCommentModel>? leadCommentModel,
    String? createdDate,
    String? updatedDate,
    int? createdById,
    UserModel? createdBy,
  }) {
    return LeadsModelWithUser(
      id: id ?? this.id,
      propertyType: propertyType ?? this.propertyType,
      mobileNo: mobileNo ?? this.mobileNo,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
      leadCommentModel: leadCommentModel ?? this.leadCommentModel,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      createdById: createdById ?? this.createdById,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyType': propertyType,
      'mobileNo': mobileNo,
      'fullName': fullName,
      'status': status,
      'leadCommentModel': leadCommentModel?.map((x) => x?.toMap())?.toList(),
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'createdById': createdById,
      'createdBy': createdBy?.toMap(),
    };
  }

  factory LeadsModelWithUser.fromMap(Map<String, dynamic> map) {
    return LeadsModelWithUser(
      id: map['id']?.toInt(),
      propertyType: map['propertyType'],
      mobileNo: map['mobileNo'],
      fullName: map['fullName'],
      status: map['status'],
      leadCommentModel: map['leadCommentModel'] != null ? List<LeadCommentModel>.from(map['leadCommentModel']?.map((x) => LeadCommentModel.fromMap(x))) : null,
      createdDate: map['createdDate'],
      updatedDate: map['updatedDate'],
      createdById: map['createdById']?.toInt(),
      createdBy: map['createdBy'] != null ? UserModel.fromMap(map['createdBy']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadsModelWithUser.fromJson(String source) => LeadsModelWithUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LeadsModelWithUser(id: $id, propertyType: $propertyType, mobileNo: $mobileNo, fullName: $fullName, status: $status, leadCommentModel: $leadCommentModel, createdDate: $createdDate, updatedDate: $updatedDate, createdById: $createdById, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LeadsModelWithUser &&
      other.id == id &&
      other.propertyType == propertyType &&
      other.mobileNo == mobileNo &&
      other.fullName == fullName &&
      other.status == status &&
      listEquals(other.leadCommentModel, leadCommentModel) &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate &&
      other.createdById == createdById &&
      other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      propertyType.hashCode ^
      mobileNo.hashCode ^
      fullName.hashCode ^
      status.hashCode ^
      leadCommentModel.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode ^
      createdById.hashCode ^
      createdBy.hashCode;
  }
}
