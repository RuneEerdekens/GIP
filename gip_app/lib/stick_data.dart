import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Uint8List format255(double x, double y, double scalar, int signal) {
  Uint8List vals = Uint8List(5);

  double dm1 = 0,
      dm2 = 0,
      dm3 = 0,
      dm4 = 0; //distance to Motor (motor in corner)

  double pDistX = 0,
      nDistX = 0,
      pDistY = 0,
      nDistY = 0; //distance along X and Y acces of current point

  pDistX = 1 - x;
  nDistX = 2 - pDistX;

  pDistY = 1 - y;
  nDistY = 2 - pDistY;

  pDistX.clamp(1, 2);
  nDistX.clamp(1, 2);
  pDistY.clamp(1, 2);
  nDistY.clamp(1, 2);

  dm1 = sqrt(pow(nDistX, 2) + pow(pDistY, 2)) - sqrt(2); //pytagoras
  dm2 = sqrt(pow(pDistX, 2) + pow(pDistY, 2)) - sqrt(2);
  dm3 = sqrt(pow(nDistX, 2) + pow(nDistY, 2)) - sqrt(2);
  dm4 = sqrt(pow(pDistX, 2) + pow(nDistY, 2)) - sqrt(2);

  vals[0] = signal;
  vals[1] = (dm1 * scalar).floor();
  vals[2] = (dm2 * scalar).floor();
  vals[3] = (dm3 * scalar).floor();
  vals[4] = (dm4 * scalar).floor();
  return vals;
}

Uint8List ud255(double y, double scalar, {int signal = 0xF3}) {
  Uint8List vals = Uint8List(5);
  vals[0] = signal;
  vals[1] = ((y + 1) * scalar).floor();
  vals[2] = vals[1];
  vals[3] = vals[1];
  vals[4] = vals[1];

  return vals;
}

Uint8List lr255(double x, double scalar, {int signal = 0xF4}) {
  return Uint8List(1);
}
