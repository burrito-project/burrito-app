import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';
import 'package:burrito/features/map/widgets/bottom_bar/bottom_bar_footer_content.dart';
import 'package:flutter/material.dart';

class WebBurritoBottomAppBar extends StatelessWidget {
  static double initialFraction = 0.06;

  const WebBurritoBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomBarHeight,
      color: Theme.of(context).colorScheme.primary,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: BottomBarFooterContent(),
      ),
    );
  }
}
