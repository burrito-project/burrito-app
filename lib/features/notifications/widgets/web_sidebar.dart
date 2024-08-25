import 'package:burrito/features/core/providers/responsive_provider.dart';
import 'package:burrito/features/core/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/notifications/widgets/notification_item.dart';
import 'package:burrito/features/notifications/provider/notifications_provider.dart';

class WebSidebar extends ConsumerStatefulWidget {
  static const maxWidth = 350.0;

  const WebSidebar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WebSidebarState();
}

class WebSidebarState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final wideScreen = ref.watch(wideScreenProvider);
    final notifications = ref.watch(notificationsProvider);

    if (!wideScreen) {
      return const SizedBox();
    }

    return Container(
      alignment: Alignment.topCenter,
      width: WebSidebar.maxWidth,
      color: Colors.black,
      child: SingleChildScrollView(
        child: notifications.when(
          data: (data) {
            final notis = data.where((n) => !n.isPopup).toList();

            return ListView.separated(
              shrinkWrap: true,
              itemCount: notis.length + 1,
              itemBuilder: (context, index) {
                if (index == notis.length) return const SizedBox();
                return NotificationItem(noti: notis[index]);
              },
              separatorBuilder: (context, index) {
                return const CustomDivider(height: 8);
              },
            );
          },
          error: (e, st) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
