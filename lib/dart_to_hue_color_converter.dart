import 'package:flutter/material.dart';

int convertColorToHue(Color color) {
  HSVColor hsvColor = HSVColor.fromColor(color);
  double hue = hsvColor.hue;
  int hueValue = (hue / 360.0 * 65535).round();

  return hueValue;
}
