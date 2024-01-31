import 'package:flutter/material.dart';

const primary = Colors.blue; //Color(0xff607d8b);
const secondary = Colors.blue;

const scaffoldBackgroundColor = Color(0xffF5F6F9);
const dividerColor = Color.fromARGB(255, 228, 223, 223);

const textColorDark = Color(0xFF344D67);
const hintColor = Color(0xFFB3B3B3);

const acceptedColor = Colors.green;
const rejectedColor = Colors.red;
const pendingColor = Colors.amber;

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Color getColorByStatus(String status) {
  switch (status) {
    case 'PENDING':
    case 'CREATED':
      return pendingColor;
    case 'APPROVED':
    case 'ACTIVE':
    case 'OPEN':
      return acceptedColor;
    case 'DECLINED':
    case 'SUSPENDED':
    case 'BLOCKED':
    case 'CLOSE':
      return rejectedColor;
    default:
      return textColorDark;
  }
}
