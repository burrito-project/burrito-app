import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/notifications/utils.dart';
import 'package:burrito/data/entities/positions_response.dart';
import 'package:burrito/features/map/providers/bus_status_provider.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/notifications/widgets/notifications_button.dart';

class BottomBarFooterContent extends ConsumerStatefulWidget {
  const BottomBarFooterContent({super.key});

  @override
  ConsumerState<BottomBarFooterContent> createState() =>
      BottomBarFooterContentState();
}

class BottomBarFooterContentState
    extends ConsumerState<BottomBarFooterContent> {
  @override
  Widget build(BuildContext context) {
    final burritoState = ref.watch(busStatusProvider);
    final isBottomSheetExpanded = ref.watch(isBottomSheetExpandedProvider);

    return Container(
      padding: const EdgeInsets.only(right: 0, left: 8),
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
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
          ),
          Row(
            children: [
              ...burritoState.when(
                data: (state) {
                  if (state.lastInfo.timestamp.timeAgoDuration.inSeconds < 60) {
                    return [const SizedBox.shrink()];
                  }
                  return [
                    const Text(
                      'Actualizado hace',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
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
                        fontSize: 14,
                      ),
                    ),
                  ];
                },
                error: (e, st) => [],
                loading: () => [],
              ),
              NotificationsButton(
                onNotificationsTap: () {
                  if (isBottomSheetExpanded) {
                    closeModalBottomSheet2(ref);
                  } else {
                    openModalBottomSheet2(ref);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
