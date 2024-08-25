import 'package:flutter/material.dart';
import 'package:burrito/features/map/widgets/bottom_bar/bottom_bar_footer_content.dart';

class WebBurritoBottomAppBar extends StatelessWidget {
  static const bottomBarHeight = 50.0;
  static double initialFraction = 0.06;

  const WebBurritoBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomBarHeight,
      color: Theme.of(context).colorScheme.primary,
      child: const BottomBarFooterContent(),
    );
  }
}
