import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../property_model.dart';


class PropertyListModel {
  List<PropertyModel>? data;
  PropertyListModel({
    this.data,
  });

  PropertyListModel copyWith({
    List<PropertyModel>? data,
  }) {
    return PropertyListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory PropertyListModel.fromMap(Map<String, dynamic> map) {
    return PropertyListModel(
      data: map['data'] != null
          ? List<PropertyModel>.from(
              map['data']?.map((x) => PropertyModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyListModel.fromJson(String source) =>
      PropertyListModel.fromMap(json.decode(source));

  @override
  String toString() => 'PropertyListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PropertyListModel && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
