import 'package:flutter/material.dart';

//原本是別的顏色，強制改成白色
const Color kRichBlack = Colors.white;
const Color kSpaceGrey = Colors.white;

const kColorScheme = ColorScheme(
  primary: Color.fromRGBO(116, 196, 199, 1),
  primaryContainer: Color.fromRGBO(116, 196, 199, 1),
  secondary: kSpaceGrey,
  secondaryContainer: kSpaceGrey,
  surface: kRichBlack,
  background: kRichBlack,
  error: Color.fromRGBO(116, 196, 199, 1),
  onPrimary: kRichBlack,
  onSecondary: Colors.grey,
  onSurface: Colors.white,
  onBackground: Colors.grey,
  onError: Colors.grey,
  brightness: Brightness.dark,
);
