import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

class CommonUtils {

  /* 颜色转换 */
  static Color string2Color(String colorString) {
    int value = 0x00000000;

    if (isNotEmpty(colorString)) {
      if (colorString[0] == '#') {
        colorString = colorString.substring(1);
      }
      value = int.tryParse(colorString, radix: 16);
      if (value != null && value < 0xFF000000) {
        value += 0xFF000000;
      }
    }

    return Color(value);
  }

  /* 删除十进制零格式 */
  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }
}