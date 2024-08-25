import 'package:burrito/features/core/utils.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReactiveFooterPadding extends ConsumerWidget {
  const ReactiveFooterPadding({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetExpansion = ref.watch(bottomSheetExpansionProvider);
    final padding = screenFractionToPixelSize(sheetExpansion, context);
    return SizedBox(height: padding);
  }
}
