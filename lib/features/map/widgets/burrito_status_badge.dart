import 'package:flutter/material.dart';
import 'package:burrito/data/entities/burrito_status.dart';

class BurritoStatusBadge extends StatelessWidget {
  final BurritoStatus status;
  static const badgeWidth = 40.0;
  static const badgeHeight = 16.0;

  const BurritoStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BurritoStatus.working:
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
                fontSize: 12,
              ),
            ),
          ),
        );
      case BurritoStatus.loading:
        return Container(
          // border rounded 8px
          color: Colors.grey,
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
        );
      case BurritoStatus.off:
        return Container(
          // border rounded 8px
          color: const Color.fromARGB(255, 128, 128, 128),
          height: badgeHeight,
          width: badgeWidth,
          child: const Center(
            child: Text(
              'OFF',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
