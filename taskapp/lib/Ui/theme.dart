import 'package:flutter/material.dart';

const Color bluishClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xffffb746);
const Color pinkClr = Color(0xffff4667);
const Color white = Colors. white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xff121212);

Color darkHeaderClr = Colors.grey.shade800;



class Themes{
  static final light = ThemeData(
  primaryColor: primaryClr,
  brightness: Brightness.light,
  useMaterial3: true,
  );

  static final dark =  ThemeData(
  primaryColor: darkGreyClr,
  brightness: Brightness.dark,
  useMaterial3: true,
  );

}
