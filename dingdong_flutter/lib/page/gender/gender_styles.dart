import 'dart:math' as math;

import 'package:dingdong_flutter/page/gender/gender.dart';
import 'package:dingdong_flutter/page/gender/widget_utils.dart';
import 'package:flutter/material.dart';

const double defaultGenderAngle = math.pi / 4;
const Map<Gender, double> genderAngles = {
  Gender.female: -defaultGenderAngle,
  Gender.other: 0.0,
  Gender.male: defaultGenderAngle,
};

double circleSize(BuildContext context) => screenAwareSize(80.0, context);
