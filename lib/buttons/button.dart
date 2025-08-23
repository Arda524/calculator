// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

Widget CustomRawMaterialButton(BuildContext context, String buttonText, void Function()? btnclicked) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
        ),
        child: RawMaterialButton(
          onPressed: btnclicked,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(14.0),
        ),
      ),
    ),
  );
}

Widget CustomRawMaterialButton2(BuildContext context, String buttonText, void Function()? btnclicked) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
        ),
        child: RawMaterialButton(
          onPressed: btnclicked,
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 26.0,
                color: Color.fromARGB(255, 252, 150, 17),
                fontWeight: FontWeight.bold),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(14.0),
        ),
      ),
    ),
  );
}

Widget CustomRawMaterialButton3(BuildContext context, String buttonText, void Function()? btnclicked) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(7),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 252, 150, 17),
            borderRadius: BorderRadius.circular(16)),
        child: RawMaterialButton(
          fillColor: const Color.fromARGB(255, 252, 150, 17),
          onPressed: btnclicked,
          child: Text(
            buttonText,
            style: const TextStyle(
                fontSize: 38.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.all(5.5),
        ),
      ),
    ),
  );
}