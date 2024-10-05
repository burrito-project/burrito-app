import 'package:burrito/features/core/alerts/simple_dialog.dart';
import 'package:burrito/features/notifications/provider/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopupNotificationsWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const PopupNotificationsWrapper({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PopupNotificationsWrapperState();
  }
}

class PopupNotificationsWrapperState
    extends ConsumerState<PopupNotificationsWrapper> {
  @override
  void initState() {
    super.initState();

    final notifications = ref.read(notificationsProvider.notifier).getFuture();

    notifications.then((notifications) async {
      final popups = notifications.where((n) => n.isPopup).toList();
      if (popups.isEmpty) return;

      if (!mounted) return;

      for (final popup in popups) {
        final content = popup.content;
        if (popup.title == null || popup.content == null) return;

        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return SimpleAppDialog(
              title: popup.title!,
              content: content!,
              showAcceptButton: true,
            );
          },
        );
      }
    }).catchError((e, st) {
      debugPrint('Error getting popup notifications: $e\n$st');
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
