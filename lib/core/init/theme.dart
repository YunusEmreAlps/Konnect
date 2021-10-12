// Libraries

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:konnect/core/constants/core.dart';

// Theme
ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: AppStrings.FONT_FAMILY,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

// Input Decoration (E-mail, Password, Name, University Name)
InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: Color(0xFF757575)),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

// Text
TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: Color(0xFF757575)), 
    bodyText2: TextStyle(color: Color(0xFF757575)),
  );
}

// App Bar (ToolBar)
AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 0,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ),
  );
}
