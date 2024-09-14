import 'package:flutter/material.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:burrito/features/notifications/entities/notification_ad.dart';

class NotificationItem extends ConsumerWidget {
  final NotificationAd noti;

  const NotificationItem({super.key, required this.noti});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (noti.isBanner) {
      return Container(
        padding: const EdgeInsets.only(right: 3),
        child: CachedNetworkImage(
          imageUrl: noti.imageUrl!,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    // Here are ads that look like newspaper posts
    return SelectionArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
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
                  fontSize: 16,
                ),
              ),
              FloatColumn(
                children: [
                  Floatable(
                    float: FCFloat.start,
                    padding: const EdgeInsets.only(right: 16, top: 8),
                    child: SizedBox(
                      width: 75,
                      child: CachedNetworkImage(
                        imageUrl: noti.imageUrl!,
                        height: 75,
                        width: 75,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  WrappableText(
                    padding: const EdgeInsets.only(top: 4),
                    text: TextSpan(
                      text: noti.content!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w200,
                        overflow: TextOverflow.fade,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
