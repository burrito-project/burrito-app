import 'package:burrito/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/core/utils.dart';
import 'package:burrito/features/map/widgets/bottom_bar/bottom_bar_footer_content.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/notifications/widgets/advertisements_carousel.dart';

const kBottomBarHeight = 70.0;
const kBottomAdvertismentHeight = 160.0;

class MobileBurritoBottomAppBar extends ConsumerStatefulWidget {
  const MobileBurritoBottomAppBar({super.key});

  @override
  ConsumerState<MobileBurritoBottomAppBar> createState() =>
      MobileBurritoBottomAppBarState();
}

class MobileBurritoBottomAppBarState
    extends ConsumerState<MobileBurritoBottomAppBar> {
  static double initialFraction = 0.06;
  static double maxFraction = 0.4;

  bool bottomSheetIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bottomSheetController = ref.watch(bottomSheetControllerProvider);

    initialFraction = pixelSizeToScreenFraction(kBottomBarHeight - 5, context);
    maxFraction = pixelSizeToScreenFraction(
      kBottomAdvertismentHeight + kBottomBarHeight + 72,
      context,
    );

    return LayoutBuilder(builder: (ctx, safeArea) {
      return NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          final isCurrentlyExpanded = notification.extent >= maxFraction - 0.01;
          ref.read(isBottomSheetExpandedProvider.notifier).update(
                (isExpanded) => isCurrentlyExpanded,
              );

          return true;
        },
        child: DraggableScrollableSheet(
          initialChildSize: initialFraction,
          minChildSize: initialFraction,
          maxChildSize: maxFraction,
          snapAnimationDuration: Durations.short4,
          snap: true,
          snapSizes: [initialFraction, maxFraction],
          controller: bottomSheetController,
          builder: (ctx, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                // physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: 4,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            margin: const EdgeInsets.only(top: 12, bottom: 2),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                          child: BottomBarFooterContent(),
                        ),
                        const SizedBox(height: 12),
                        const AdvertisementsCarousel(),
                        const SizedBox(height: 12),
                        FutureBuilder(
                          future: kPackageInfo,
                          builder: (ctx, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final packageInfo = snapshot.data!;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).hintColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Contigo Burrito UNMSM',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'v${packageInfo.version}+${packageInfo.buildNumber}',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
