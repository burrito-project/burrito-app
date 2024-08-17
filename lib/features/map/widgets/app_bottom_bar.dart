import 'package:burrito/features/core/utils.dart';
import 'package:burrito/features/map/widgets/bottom_info.dart';
import 'package:flutter/material.dart';

const kBottomBarHeight = 70.0;

class BurritoBottomAppBar extends StatelessWidget {
  final DraggableScrollableController controller;

  static double initialFraction = 0.06;

  const BurritoBottomAppBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    initialFraction = pixelSizeToScreenFraction(kBottomBarHeight, context);

    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: BottomBurritoInfo(),
      ),
    );
  }
}
