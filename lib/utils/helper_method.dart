import 'dart:math';

import 'package:flutter/material.dart';
import 'package:propertycp_customer/utils/theme.dart';
import 'package:propertycp_customer/widgets/responsive.dart';

import '../models/user_model.dart';

String getOTPCode() {
  return (Random().nextInt(900000) + 100000).toString();
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

int containsUser(Map<UserModel, int>? userMap, int id) {
  int count = 0;
  for (UserModel userModel in userMap?.keys.toList() ?? []) {
    if (userModel.id == id) count++;
  }
  return count;
}

double getAppbarSpacing(BuildContext context) {
  if (Responsive.isDesktop(context)) {
    return defaultPadding * 2;
  } else {
    return defaultPadding;
  }
}
