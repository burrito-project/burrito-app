import 'package:flutter/material.dart';
import 'package:burrito/data/entities/burrito_status.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BurritoStatusBadge extends StatelessWidget {
  final BusServiceStatus status;
  static const badgeWidth = 44.0;
  static const badgeHeight = 16.0;
  static const fontSize = 12.0;
  static const grayColor = Color(0xFF808080);

  const BurritoStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BusServiceStatus.working:
        return Container(
          color: Colors.red,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: Text(
              'LIVE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        );
      case BusServiceStatus.loading:
        return Container(
          color: grayColor,
          height: badgeHeight,
          width: badgeWidth,
          child: SizedBox(
            height: 12,
            width: 12,
            child: Center(
              child: LoadingAnimationWidget.horizontalRotatingDots(
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        );
      case BusServiceStatus.off:
        return Container(
          color: grayColor,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: Text(
              'OFF',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
