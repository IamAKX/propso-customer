import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../leads_model.dart';


class LeadListModel {
  List<LeadsModel>? data;
  LeadListModel({
    this.data,
  });

  LeadListModel copyWith({
    List<LeadsModel>? data,
  }) {
    return LeadListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory LeadListModel.fromMap(Map<String, dynamic> map) {
    return LeadListModel(
      data: map['data'] != null
          ? List<LeadsModel>.from(
              map['data']?.map((x) => LeadsModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LeadListModel.fromJson(String source) =>
      LeadListModel.fromMap(json.decode(source));

  @override
  String toString() => 'LeadListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LeadListModel && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
