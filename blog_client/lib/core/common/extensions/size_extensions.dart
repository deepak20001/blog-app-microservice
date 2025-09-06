import 'package:flutter/material.dart';

extension SizeExtensions on BuildContext {
  SizedBox sizedBoxHeight(double percentage) {
    return SizedBox(height: MediaQuery.sizeOf(this).width * percentage);
  }

  SizedBox sizedBoxWidth(double percentage) {
    return SizedBox(width: MediaQuery.sizeOf(this).width * percentage);
  }
}
