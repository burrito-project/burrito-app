import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> openModalBottomSheet(Ref ref) async {
  await ref.read(bottomSheetControllerProvider).animateTo(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.maxFraction;
}

Future<void> closeModalBottomSheet(Ref ref) async {
  await ref.read(bottomSheetControllerProvider).animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.minFraction;
}

Future<void> openModalBottomSheet2(WidgetRef ref) async {
  await ref.read(bottomSheetControllerProvider).animateTo(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.maxFraction;
}

Future<void> closeModalBottomSheet2(WidgetRef ref) async {
  await ref.read(bottomSheetControllerProvider).animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.minFraction;
}
