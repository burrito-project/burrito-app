import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/notifications/widgets/notification_item.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';
import 'package:burrito/features/notifications/provider/notifications_provider.dart';

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
      options: FlutterCarouselOptions(
        height: kBottomAdvertismentHeight,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        viewportFraction: 0.98,
        disableCenter: true,
        showIndicator: false,
        padEnds: false,
        autoPlay: isBottomSheetExpanded,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(
          milliseconds: 500,
        ),
        pauseAutoPlayOnTouch: true,
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: notifications.when(
        data: (notificatons) {
          if (notificatons.isEmpty) {
            return [const NotificationsEmpty()];
          }
          return notificatons.where((n) => !n.isPopup).map((noti) {
            return NotificationItem(noti: noti);
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
