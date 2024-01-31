import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../leads_model_with_user.dart';


class LeadWithUserListModel {
  List<LeadsModelWithUser>? data;
  LeadWithUserListModel({
    this.data,
  });

  LeadWithUserListModel copyWith({
    List<LeadsModelWithUser>? data,
  }) {
    return LeadWithUserListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x?.toMap())?.toList(),
    };
  }

  factory LeadWithUserListModel.fromMap(Map<String, dynamic> map) {
    return LeadWithUserListModel(
      data: map['data'] != null ? List<LeadsModelWithUser>.from(map['data']?.map((x) => LeadsModelWithUser.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadWithUserListModel.fromJson(String source) => LeadWithUserListModel.fromMap(json.decode(source));

  @override
  String toString() => 'LeadWithUserListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LeadWithUserListModel &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
