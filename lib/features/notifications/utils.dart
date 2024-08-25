import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> openModalBottomSheet(Ref ref) async {
  await _animateIfAttached(ref.read, 1);
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.maxFraction;
}

Future<void> closeModalBottomSheet(Ref ref) async {
  await _animateIfAttached(ref.read, 0);
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.minFraction;
}

Future<void> openModalBottomSheet2(WidgetRef ref) async {
  await _animateIfAttached(ref.read, 1);
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.maxFraction;
}

Future<void> closeModalBottomSheet2(WidgetRef ref) async {
  await _animateIfAttached(ref.read, 0);
  ref.read(bottomSheetExpansionProvider.notifier).state =
      MobileBurritoBottomAppBarState.minFraction;
}

Future<void> _animateIfAttached(
  dynamic Function(ProviderListenable<dynamic>) readProvider,
  double to,
) async {
  final controller = readProvider(bottomSheetControllerProvider);
  if (!controller.isAttached) return;
  await controller.animateTo(
    to,
    duration: const Duration(milliseconds: 300),
    curve: Curves.ease,
  );
}
