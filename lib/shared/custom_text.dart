import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.textColor,
      this.fontSize,
      this.fontWeight,
      this.heightText,
      this.maxLines,
      this.fontfamily,
      this.letterSpacing,
      this.textalign});

  final String text;
  final double? fontSize;
  final Color? textColor;
  final String? fontfamily;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? heightText;
  final TextAlign? textalign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor ?? AppColors.whiteColor,
        fontSize: fontSize ?? 14.sp,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: fontfamily ?? 'Cairo',
        letterSpacing: letterSpacing ?? 0,
      ),
      textAlign: textalign ?? TextAlign.right,
    );
  }
}
