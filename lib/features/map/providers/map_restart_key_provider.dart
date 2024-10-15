import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapKeyProvider = StateProvider<Key>(
  (ref) => UniqueKey(),
);

void reloadMap(WidgetRef ref) {
  ref.read(mapKeyProvider.notifier).state = UniqueKey();
}
