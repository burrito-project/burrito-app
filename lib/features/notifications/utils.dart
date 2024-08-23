import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> openModalBottomSheet(Ref ref) {
  return ref.read(bottomSheetControllerProvider).animateTo(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
}

Future<void> closeModalBottomSheet(Ref ref) {
  return ref.read(bottomSheetControllerProvider).animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
}

Future<void> openModalBottomSheet2(WidgetRef ref) {
  return ref.read(bottomSheetControllerProvider).animateTo(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
}

Future<void> closeModalBottomSheet2(WidgetRef ref) {
  return ref.read(bottomSheetControllerProvider).animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
}
