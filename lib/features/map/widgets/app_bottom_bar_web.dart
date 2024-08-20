import 'package:burrito/features/map/widgets/app_bottom_bar_mobile.dart';
import 'package:burrito/features/map/widgets/bottom_info.dart';
import 'package:flutter/material.dart';

class WebBurritoBottomAppBar extends StatelessWidget {
  final DraggableScrollableController controller;

  static double initialFraction = 0.06;

  const WebBurritoBottomAppBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomBarHeight,
      color: Theme.of(context).colorScheme.primary,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: BottomBurritoInfo(),
      ),
    );
  }
}
