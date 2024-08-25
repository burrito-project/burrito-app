import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/features/core/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/app_updates/widgets/new_update_button.dart';
import 'package:burrito/features/notifications/widgets/advertisements_carousel.dart';
import 'package:burrito/features/app_updates/providers/pending_updates_provider.dart';
import 'package:burrito/features/map/widgets/bottom_bar/bottom_bar_footer_content.dart';

const kBottomAdvertismentHeight = 150.0;

class MobileBurritoBottomAppBar extends ConsumerStatefulWidget {
  const MobileBurritoBottomAppBar({super.key});

  @override
  ConsumerState<MobileBurritoBottomAppBar> createState() =>
      MobileBurritoBottomAppBarState();
}

class MobileBurritoBottomAppBarState
    extends ConsumerState<MobileBurritoBottomAppBar> {
  static const bottomBarHeight = 70.0;
  static double minFraction = 0.06;
  static double maxFraction = 0.4;

  bool bottomSheetIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bottomSheetController = ref.watch(bottomSheetControllerProvider);
    final pendingUpdates = ref.watch(pendingUpdatesProvider);

    final hasUpdates = !kIsWeb &&
        pendingUpdates.hasValue &&
        pendingUpdates.valueOrNull!.versions.isNotEmpty;

    minFraction = pixelSizeToScreenFraction(bottomBarHeight - 5, context);
    maxFraction = pixelSizeToScreenFraction(
      kBottomAdvertismentHeight + 24 + bottomBarHeight + (hasUpdates ? 64 : 0),
      context,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bottomSheetExpansionProvider.notifier).state =
          bottomSheetController.size;
    });

    return LayoutBuilder(builder: (ctx, safeArea) {
      return ScrollConfiguration(
        behavior: WebMobileScrollBehavior(),
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            ref.read(bottomSheetExpansionProvider.notifier).state =
                notification.extent;
            return true;
          },
          // PointerDeviceKind.mouse
          child: DraggableScrollableSheet(
            initialChildSize: maxFraction,
            minChildSize: minFraction,
            maxChildSize: maxFraction,
            snapAnimationDuration: Durations.short4,
            snap: true,
            snapSizes: [minFraction, maxFraction],
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
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: false,
                      child: Column(
                        children: [
                          _draggableTip(),
                          const SizedBox(
                            height: 40,
                            child: BottomBarFooterContent(),
                          ),
                          const SizedBox(height: 10),
                          const AdvertisementsCarousel(),
                          ...pendingUpdates.when(
                            data: (r) {
                              if (r.versions.isEmpty) {
                                return const [];
                              }

                              return [
                                const SizedBox(height: 6),
                                Expanded(child: NewAppUpdateButton(updates: r)),
                              ];
                            },
                            error: (e, st) {
                              debugPrint(
                                'Error fetching pending updates: $e\n$st',
                              );
                              return [];
                            },
                            loading: () => [],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _draggableTip() => Center(
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
      );
}

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
              'Contigo Burrito',
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
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
    );
  }
}

class WebMobileScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
