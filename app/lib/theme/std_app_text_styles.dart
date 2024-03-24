import 'package:flutter/material.dart';
import 'package:totem/theme/index.dart';

class StdAppTextStyles extends AppTextStyles {
  StdAppTextStyles(AppThemeColors themeColors)
      : super(
          headline1: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              height: 43.52 / 32,
              color: themeColors.primaryText),
          bodyLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          bodyMedium: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          button: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          pinInput: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          headline2: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: themeColors.secondaryText),
          headline6: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          headline3: TextStyle(
              fontSize: 16,
              height: 18.78 / 16,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          headline4: TextStyle(
              fontSize: 14,
              height: 18 / 14,
              fontWeight: FontWeight.w500,
              color: themeColors.secondaryText),
          headline5: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: themeColors.reversedText),
          inputLabel: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeColors.primaryText),
          formErrorLabel: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: themeColors.error),
          textLinkButton: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: themeColors.linkText),
          dialogContent: TextStyle(
              fontSize: 16,
              color: themeColors.primaryText,
              fontWeight: FontWeight.normal),
          dialogTitle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: themeColors.primaryText),
          hintInputLabel: TextStyle(
              fontSize: 14,
              color: themeColors.secondaryText,
              fontWeight: FontWeight.w500),
          nextTag: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: themeColors.primaryText),
        );
}
