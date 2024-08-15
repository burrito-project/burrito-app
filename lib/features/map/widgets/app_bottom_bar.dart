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

    return LayoutBuilder(builder: (ctx, safeArea) {
      return DraggableScrollableSheet(
        initialChildSize: initialFraction,
        minChildSize: initialFraction,
        maxChildSize: 0.6,
        snapAnimationDuration: Durations.short4,
        snap: true,
        snapSizes: [initialFraction, 0.6],
        controller: controller,
        builder: (ctx, scrollController) {
          return Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
                const BottomBurritoInfo(),
              ],
            ),
          );
        },
      );
    });
  }
}
