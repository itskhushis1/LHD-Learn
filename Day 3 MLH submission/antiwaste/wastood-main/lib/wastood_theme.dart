import 'package:flutter/material.dart';

class WastoodTheme {
  final primaryColor = Color(0xFF5DB075);

  ThemeData get themeData {
    return ThemeData(
      fontFamily: 'Inter',
      brightness: Brightness.light,
      primaryColor: primaryColor,
      accentColor: primaryColor,
      cursorColor: primaryColor,
      textSelectionColor: primaryColor,
      textSelectionHandleColor: primaryColor,
      canvasColor: Colors.white,
      errorColor: Color(0xFFB05D5D),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      //iconTheme: IconThemeData(color: Color(0xFF5DB075)),

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.w700),
        headline6: TextStyle(fontSize: 36.0),
        bodyText2: TextStyle(fontSize: 14.0),
      ).apply(fontFamily: 'Inter'),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF6F6F6),
        contentPadding:
            const EdgeInsets.only(left: 16.0, bottom: 16.0, top: 16.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.circular(8),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: TextTheme(
                headline6: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))
            .apply(fontFamily: 'Inter'),
      ),
    );
  }
}
