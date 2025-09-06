import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightThemeMode(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPallete.backgroundColor,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w900,
          fontSize: size.width * numD14,
          color: AppPallete.blackColor,
        ),
        displayMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: size.width * numD12,
          color: AppPallete.blackColor,
        ),
        displaySmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: size.width * numD09,
          color: AppPallete.blackColor,
        ),
        headlineLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: size.width * numD08,
          color: AppPallete.blackColor,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: size.width * numD07,
          color: AppPallete.blackColor,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: size.width * numD035,
          color: AppPallete.blackColor,
        ),
        titleLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: size.width * numD055,
          color: AppPallete.blackColor,
        ),
        titleMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: size.width * numD04,
          color: AppPallete.blackColor,
        ),
        titleSmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: size.width * numD035,
          color: AppPallete.blackColor,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: size.width * numD04,
          color: AppPallete.blackColor,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: size.width * numD035,
          color: AppPallete.blackColor,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
          fontSize: size.width * numD033,
          color: AppPallete.blackColor,
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: size.width * numD035,
          color: AppPallete.blackColor,
        ),
        labelMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: size.width * numD033,
          color: AppPallete.blackColor,
        ),
        labelSmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.w300,
          fontSize: size.width * numD03,
          color: AppPallete.blackColor,
        ),
      ),
    );
  }
}
