import 'package:flutter/material.dart';
class CColors {

static  Color primary = const Color(0xff46934C);
static Color secondary = const Color(0xff5EB56A);
static Color secondarydark = const Color(0xff1C5B2A);
static  Color background = const Color(0xffCCFDD2);
static  Color bottomAppBarcolor = const Color(0xffa3e6a5);

static Color greenGrad1 = const Color(0xff01AA45);
static Color greenGrad2 = const Color(0xff00702D);



}
Map<int, Color> getSwatch(Color color) {
  final hslColor = HSLColor.fromColor(color);
  final lightness = hslColor.lightness;
  const lowDivisor = 6;
  const highDivisor = 5;
  final lowStep = (1.0 - lightness) / lowDivisor;
  final highStep = lightness / highDivisor;
  return {
    50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
    100: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
    200: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
    300: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
    400: (hslColor.withLightness(lightness + lowStep)).toColor(),
    500: (hslColor.withLightness(lightness)).toColor(),
    600: (hslColor.withLightness(lightness - highStep)).toColor(),
    700: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    800: (hslColor.withLightness(lightness - (highStep * 3))).toColor(),
    900: (hslColor.withLightness(lightness - (highStep * 4))).toColor(),
  };
}

MaterialColor getMaterialColor(Color primary) {
  return MaterialColor(primary.value, getSwatch(primary));
}

