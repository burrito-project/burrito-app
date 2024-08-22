import 'package:burrito/features/notifications/provider/notifications_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';

class AdvertisementsCarousel extends ConsumerStatefulWidget {
  const AdvertisementsCarousel({super.key});

  @override
  ConsumerState<AdvertisementsCarousel> createState() =>
      AdvertisementsCarouselState();
}

class AdvertisementsCarouselState
    extends ConsumerState<AdvertisementsCarousel> {
  @override
  Widget build(BuildContext context) {
    final isBottomSheetExpanded = ref.watch(isBottomSheetExpandedProvider);
    final notifications = ref.watch(notificationsProvider);

    return FlutterCarousel(
      options: CarouselOptions(
        height: kBottomAdvertismentHeight,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        viewportFraction: 0.98,
        disableCenter: true,
        showIndicator: false,
        padEnds: false,
        autoPlay: isBottomSheetExpanded,
        autoPlayInterval: const Duration(seconds: 10),
        autoPlayAnimationDuration: const Duration(
          milliseconds: 500,
        ),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: notifications.when(
        data: (notificatons) {
          if (notificatons.isEmpty) {
            return [const NotificationsEmpty()];
          }
          return notificatons.where((n) => !n.isPopup).map((noti) {
            if (noti.isBanner) {
              return CachedNetworkImage(
                imageUrl: noti.imageUrl!,
                // fixed height, and crop to fit the width in the screen
                height: kBottomAdvertismentHeight,
                fit: BoxFit.cover,
              );
            }

            // Here are ads that look like newspaper posts
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              color: Theme.of(context).colorScheme.secondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    noti.title!,
                    maxLines: 2,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              noti.content!,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                overflow: TextOverflow.fade,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl: noti.imageUrl!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        error: (e, st) => [const NotificationsEmpty()],
        loading: () => [const NotificationsEmpty()],
      ),
    );
  }
}

class NotificationsEmpty extends StatelessWidget {
  const NotificationsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¡Estás al día!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Aquí aparecerán futuras notificaciones',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w200,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
