import 'package:flutter/material.dart';
import 'package:totem/components/widgets/index.dart';
import 'package:totem/theme/index.dart';

class ThemedTextFormField extends StatelessWidget {
  const ThemedTextFormField({
    Key? key,
    this.labelText,
    this.labelStyle,
    this.controller,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.cursorColor,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = false,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.autovalidateMode,
    this.autofocus = false,
    this.onEditingComplete,
    this.suffixIcon,
  }) : super(key: key);
  final String? labelText;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? cursorColor;
  final bool autocorrect;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;
  final AutovalidateMode? autovalidateMode;
  final bool autofocus;
  final void Function()? onEditingComplete;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textStyles = themeData.textStyles;
    final themeColors = themeData.themeColors;

    return TextFormField(
      decoration: ThemedInputDecoration(
        labelText: labelText,
        themeColors: themeColors,
        textStyles: textStyles,
        suffixIcon: suffixIcon,
      ),
      controller: controller,
      autocorrect: autocorrect,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: cursorColor ?? themeColors.primaryText,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines > 0 ? maxLines : null,
      autovalidateMode: autovalidateMode,
      autofocus: autofocus,
      onEditingComplete: onEditingComplete,
    );
  }
}
