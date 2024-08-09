import 'package:flutter/widgets.dart';

double pixelSizeToScreenFraction(num pixel, BuildContext context) {
  return pixel / MediaQuery.sizeOf(context).height;
}
