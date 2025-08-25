// ignore_for_file: non_constant_identifier_names, sort_child_properties_last

import 'package:flutter/material.dart';

enum ButtonType {
  number,
  operator,
  equals,
  function
}

Widget calculatorButton(BuildContext context, String buttonText, void Function()? onPressed, {ButtonType type = ButtonType.number}) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  Color backgroundColor;
  Color textColor;
  double fontSize;
  EdgeInsets padding;

  switch (type) {
    case ButtonType.number:
      backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
      textColor = isDarkMode ? Colors.white : Colors.black;
      fontSize = 26.0;
      padding = const EdgeInsets.all(14.0);
      break;
    case ButtonType.operator:
      backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
      textColor = const Color.fromARGB(255, 252, 150, 17);
      fontSize = 26.0;
      padding = const EdgeInsets.all(14.0);
      break;
    case ButtonType.equals:
      backgroundColor = const Color.fromARGB(255, 252, 150, 17);
      textColor = Colors.white;
      fontSize = 38.0;
      padding = const EdgeInsets.all(5.5);
      break;
    case ButtonType.function:
      backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.white;
      textColor = isDarkMode ? Colors.white : Colors.black;
      fontSize = 26.0;
      padding = const EdgeInsets.all(14.0);
      break;
  }

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: type != ButtonType.equals && !isDarkMode
              ? [
                  BoxShadow(
                    color: Colors.grey.withAlpha(51),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: RawMaterialButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: padding,
        ),
      ),
    ),
  );
}

// Legacy functions for backward compatibility
Widget CustomRawMaterialButton(BuildContext context, String buttonText, void Function()? btnclicked) {
  return calculatorButton(context, buttonText, btnclicked, type: ButtonType.number);
}

Widget CustomRawMaterialButton2(BuildContext context, String buttonText, void Function()? btnclicked) {
  return calculatorButton(context, buttonText, btnclicked, type: ButtonType.operator);
}

Widget CustomRawMaterialButton3(BuildContext context, String buttonText, void Function()? btnclicked) {
  return calculatorButton(context, buttonText, btnclicked, type: ButtonType.equals);
}
