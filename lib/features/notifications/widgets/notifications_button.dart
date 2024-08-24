import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/notifications/widgets/notification_bell_icon.dart';
import 'package:burrito/features/notifications/provider/notifications_provider.dart';

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
    final unseen = ref.watch(unseenNotificationsProvider);

    return Semantics(
      label: 'Notificaciones',
      excludeSemantics: true,
      button: true,
      enabled: true,
      child: InkWell(
        enableFeedback: true,
        onTap: () {
          widget.onNotificationsTap.call();
          ref
              .read(notificationsProvider.notifier)
              .triggerOpenNotificationsFeed();
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 6, left: 12),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: NotificationBellIcon(count: unseen),
          ),
        ),
      ),
    );
  }
}
