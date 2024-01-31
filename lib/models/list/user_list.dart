import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../user_model.dart';


class UserListModel {
  List<UserModel>? data;
  UserListModel({
    this.data,
  });

  UserListModel copyWith({
    List<UserModel>? data,
  }) {
    return UserListModel(
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data?.map((x) => x.toMap()).toList(),
    };
  }

  factory UserListModel.fromMap(Map<String, dynamic> map) {
    return UserListModel(
      data: map['data'] != null ? List<UserModel>.from(map['data']?.map((x) => UserModel.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserListModel.fromJson(String source) => UserListModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserListModel(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserListModel &&
      listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}
