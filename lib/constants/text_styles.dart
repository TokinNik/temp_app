import 'package:flutter/cupertino.dart';
import 'package:temp_app/constants/colors.dart';

class AppStyle {
  AppStyle._();
  //TODO: Change to your font family
  static final String fontFamily = "Monospace";

  static final TextStyle baseStyle = TextStyle(fontFamily: fontFamily);

  static TextStyle mainTextStyle({Color? color}) {
    return baseStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.black,
    );
  }
}
