import 'package:flutter/material.dart';
import 'package:phytosvit/style/colors.dart';

InputDecoration customInputDecoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    hintStyle: TextStyle(
      color: AppColors.textInputColorDay,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.greenTeeColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: AppColors.inputBorderColor,
      ),
    ),
  );
}
