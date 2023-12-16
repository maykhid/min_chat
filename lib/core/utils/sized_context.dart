import 'dart:math';

import 'package:flutter/material.dart';

extension SizedContext on BuildContext {
  /// Returns same as MediaQuery.of(context)
  MediaQueryData get _mediaQuery => MediaQuery.of(this);

  /// Returns if Orientation is landscape
  bool get isLandscape => _mediaQuery.orientation == Orientation.landscape;

  /// Returns same as MediaQuery.of(context).size
  Size get size => _mediaQuery.size;

  /// Returns same as MediaQuery.of(context).size.width
  double get width => size.width;

  /// Returns same as MediaQuery.of(context).height
  double get height => size.height;

  /// Returns diagonal screen pixels
  double get diagonal {
    final s = size;
    return sqrt((s.width * s.width) + (s.height * s.height));
  }
}
