import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData kLightThemeData = ThemeData(
  appBarTheme: AppBarTheme(centerTitle: false, elevation: 0),
  primaryColor: Color(0xFF5a8fbb),
  backgroundColor: Color(0xFFffffff),
  scaffoldBackgroundColor: Color(0xFFffffff),
  canvasColor: Color(0xFFffffff),
  accentColor: Color(0xFF8b9094),
  shadowColor: Color(0x60000000),
  iconTheme: IconThemeData(color: Color(0xFF8b9094)),
  textTheme: _textTheme(Color(0xFF3f3f3f)),
  dialogBackgroundColor: Color(0xFFffffff),
);

TextTheme _textTheme(Color textColor) => TextTheme(
  headline1: GoogleFonts.roboto(fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5, color: textColor),
  headline2: GoogleFonts.roboto(fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5, color: textColor),
  headline3: GoogleFonts.roboto(fontSize: 48, fontWeight: FontWeight.w400, color: textColor),
  headline4: GoogleFonts.roboto(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: textColor),
  headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w400, color: textColor),
  headline6: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15, color: textColor),
  subtitle1: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: textColor),
  subtitle2: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1, color: textColor),
  bodyText1: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: textColor),
  bodyText2: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: textColor),
  button: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25, color: textColor),
  caption: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: textColor),
  overline: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5, color: textColor),
);

ThemeData kDarkThemeData = ThemeData(
  appBarTheme: AppBarTheme(centerTitle: false, elevation: 0),
  primaryColor: Color(0xFF223040),
  backgroundColor: Color(0xFF1f2334),
  scaffoldBackgroundColor: Color(0xFF1f2334),
  canvasColor: Color(0xFF1f2334),
  accentColor: Color(0xFF5a8fbb),
  shadowColor: Color(0x30000000),
  iconTheme: IconThemeData(color: Color(0xFF8b9094)),
  textTheme: _textTheme(Color(0xffd6d6d6)),
  dialogBackgroundColor: Color(0xFF223040),
);
