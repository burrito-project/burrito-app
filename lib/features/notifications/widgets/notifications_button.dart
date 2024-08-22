import 'package:burrito/features/notifications/provider/notifications_provider.dart';
import 'package:burrito/features/notifications/widgets/notification_bell_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationsButton extends ConsumerStatefulWidget {
  final VoidCallback onNotificationsTap;

  const NotificationsButton({
    super.key,
    required this.onNotificationsTap,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      NotificationsButtonState();
}

class NotificationsButtonState extends ConsumerState<NotificationsButton> {
  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);

    return InkWell(
      enableFeedback: true,
      onTap: widget.onNotificationsTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 6, left: 12),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: notifications.when(
            data: (notifications) =>
                NotificationBellIcon(count: notifications.length),
            error: (e, st) => const NotificationBellIcon(count: 0),
            loading: () => const NotificationBellIcon(count: 0),
          ),
        ),
      ),
    );
  }
}
