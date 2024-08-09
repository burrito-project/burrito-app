import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:burrito/features/map/providers/bus_status_provider.dart';

class BottomBurritoInfo extends ConsumerStatefulWidget {
  const BottomBurritoInfo({super.key});

  @override
  ConsumerState<BottomBurritoInfo> createState() => BottomBurritoInfoState();
}

class BottomBurritoInfoState extends ConsumerState<BottomBurritoInfo> {
  @override
  Widget build(BuildContext context) {
    final burritoState = ref.watch(busStatusProvider);

    return Container(
      padding: const EdgeInsets.only(right: 10, left: 8),
      color: Theme.of(context).colorScheme.primary,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.speed_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  burritoState.when(
                    data: (state) => state.lastInfo.velocity.kmphString,
                    error: (e, st) => 0.0.kmphString,
                    loading: () => 0.0.kmphString,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Actualizado hace',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  burritoState.when(
                    data: (state) => state.lastInfo.timestamp.timeAgoString,
                    error: (e, st) => '?',
                    loading: () => '?',
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
