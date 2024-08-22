import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isBottomSheetExpandedProvider = StateProvider<bool>((ref) => false);

final bottomSheetControllerProvider =
    StateProvider<DraggableScrollableController>(
        (ref) => DraggableScrollableController());
