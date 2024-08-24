import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';

final isBottomSheetExpandedProvider = StateProvider<bool>(
  (ref) {
    final extent = ref.watch(bottomSheetExpansionProvider);
    return extent >= MobileBurritoBottomAppBarState.maxFraction - 0.01;
  },
);

final bottomSheetExpansionProvider = StateProvider<double>(
  (ref) => MobileBurritoBottomAppBarState.maxFraction,
);

final bottomSheetControllerProvider =
    StateProvider<DraggableScrollableController>(
  (ref) => DraggableScrollableController(),
);
