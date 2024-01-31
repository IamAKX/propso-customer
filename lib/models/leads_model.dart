import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:propertycp_customer/models/lead_comment_model.dart';

class LeadsModel {
  int? id;
  String? propertyType;
  String? leadPropertyType;
  String? mobileNo;
  String? fullName;
  String? status;
  List<LeadCommentModel>? leadCommentModel;
  String? createdDate;
  String? updatedDate;
  int? createdById;
  int? propertyId;
  LeadsModel({
    this.id,
    this.propertyType,
    this.leadPropertyType,
    this.mobileNo,
    this.fullName,
    this.status,
    this.leadCommentModel,
    this.createdDate,
    this.updatedDate,
    this.createdById,
    this.propertyId,
  });

  LeadsModel copyWith({
    int? id,
    String? propertyType,
    String? leadPropertyType,
    String? mobileNo,
    String? fullName,
    String? status,
    List<LeadCommentModel>? leadCommentModel,
    String? createdDate,
    String? updatedDate,
    int? createdById,
    int? propertyId,
  }) {
    return LeadsModel(
      id: id ?? this.id,
      propertyType: propertyType ?? this.propertyType,
      leadPropertyType: leadPropertyType ?? this.leadPropertyType,
      mobileNo: mobileNo ?? this.mobileNo,
      fullName: fullName ?? this.fullName,
      status: status ?? this.status,
      leadCommentModel: leadCommentModel ?? this.leadCommentModel,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      createdById: createdById ?? this.createdById,
      propertyId: propertyId ?? this.propertyId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(propertyType != null){
      result.addAll({'propertyType': propertyType});
    }
    if(leadPropertyType != null){
      result.addAll({'leadPropertyType': leadPropertyType});
    }
    if(mobileNo != null){
      result.addAll({'mobileNo': mobileNo});
    }
    if(fullName != null){
      result.addAll({'fullName': fullName});
    }
    if(status != null){
      result.addAll({'status': status});
    }
    if(leadCommentModel != null){
      result.addAll({'leadCommentModel': leadCommentModel!.map((x) => x?.toMap()).toList()});
    }
    if(createdDate != null){
      result.addAll({'createdDate': createdDate});
    }
    if(updatedDate != null){
      result.addAll({'updatedDate': updatedDate});
    }
    if(createdById != null){
      result.addAll({'createdById': createdById});
    }
    if(propertyId != null){
      result.addAll({'propertyId': propertyId});
    }
  
    return result;
  }

  factory LeadsModel.fromMap(Map<String, dynamic> map) {
    return LeadsModel(
      id: map['id']?.toInt(),
      propertyType: map['propertyType'],
      leadPropertyType: map['leadPropertyType'],
      mobileNo: map['mobileNo'],
      fullName: map['fullName'],
      status: map['status'],
      leadCommentModel: map['leadCommentModel'] != null ? List<LeadCommentModel>.from(map['leadCommentModel']?.map((x) => LeadCommentModel.fromMap(x))) : null,
      createdDate: map['createdDate'],
      updatedDate: map['updatedDate'],
      createdById: map['createdById']?.toInt(),
      propertyId: map['propertyId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadsModel.fromJson(String source) => LeadsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LeadsModel(id: $id, propertyType: $propertyType, leadPropertyType: $leadPropertyType, mobileNo: $mobileNo, fullName: $fullName, status: $status, leadCommentModel: $leadCommentModel, createdDate: $createdDate, updatedDate: $updatedDate, createdById: $createdById, propertyId: $propertyId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LeadsModel &&
      other.id == id &&
      other.propertyType == propertyType &&
      other.leadPropertyType == leadPropertyType &&
      other.mobileNo == mobileNo &&
      other.fullName == fullName &&
      other.status == status &&
      listEquals(other.leadCommentModel, leadCommentModel) &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate &&
      other.createdById == createdById &&
      other.propertyId == propertyId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      propertyType.hashCode ^
      leadPropertyType.hashCode ^
      mobileNo.hashCode ^
      fullName.hashCode ^
      status.hashCode ^
      leadCommentModel.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode ^
      createdById.hashCode ^
      propertyId.hashCode;
  }
}
