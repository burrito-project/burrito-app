import 'package:flutter/widgets.dart';

double pixelSizeToScreenFraction(num pixel, BuildContext context) {
  return pixel / MediaQuery.sizeOf(context).height;
}

double screenFractionToPixelSize(num fraction, BuildContext context) {
  final padding = MediaQueryData.fromView(View.of(context)).padding;
  return fraction *
      (MediaQuery.sizeOf(context).height - padding.top - padding.bottom);
}
