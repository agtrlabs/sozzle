import 'package:flutter/material.dart';
import 'package:sozzle/src/resources/color_manager.dart';
import 'package:sozzle/src/resources/font_manager.dart';

import 'package:sozzle/src/resources/styles_manager.dart';

import 'package:sozzle/src/resources/values_manager.dart';

class Themes {
  ThemeData getLigthTheme() {
    return ThemeData(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: ColorManager.blue,
        onPrimary: ColorManager.white,
        secondary: ColorManager.lightBlue,
        onSecondary: ColorManager.white,
        error: ColorManager.error,
        onError: ColorManager.white,
        background: ColorManager.darkBlue,
        onBackground: ColorManager.white,
        surface: ColorManager.lightViolet,
        onSurface: ColorManager.white,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        color: ColorManager.lightBlue,
        elevation: 4,
        shadowColor: ColorManager.black,
        titleTextStyle: const TextStyle(color: Colors.green),
      ),
      scaffoldBackgroundColor: Colors.blue,
      // Button theme
      buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(),
        disabledColor: ColorManager.grey1,
        buttonColor: Colors.red,
        splashColor: ColorManager.primaryOpacity70,
      ),

      // elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: getRegularStyle(color: ColorManager.white),
          backgroundColor: ColorManager.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.s12),
          ),
        ),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: getSemiBoldStyle(
          color: ColorManager.darkGrey,
          fontSize: FontSize.s16,
        ),
        titleMedium: getMediumStyle(
          color: ColorManager.lightGrey,
          fontSize: FontSize.s14,
        ),
        titleSmall: getMediumStyle(
          color: ColorManager.blue,
          fontSize: FontSize.s14,
        ),
        bodySmall: getRegularStyle(color: ColorManager.grey1),
        bodyLarge: getRegularStyle(color: ColorManager.grey),
      ),

      iconTheme: const IconThemeData(
        color: Colors.white,
        // size: 24,
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData.dark();
  }
}
