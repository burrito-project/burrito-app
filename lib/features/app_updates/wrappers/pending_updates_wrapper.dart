import 'package:burrito/features/app_updates/widgets/new_version_dialog.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingUpdatesWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const PendingUpdatesWrapper({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PendingUpdatesWrapperState();
  }
}

const updatePopupsAreAThing = false;

class PendingUpdatesWrapperState extends ConsumerState<PendingUpdatesWrapper> {
  @override
  void initState() {
    super.initState();

    if (kIsWeb) return; // web is (well, should be) always up to date
    // if (!updatePopupsAreAThing) return;

    getPendingUpdates().then((response) async {
      if (response.versions.isNotEmpty) {
        if (!mounted) return;
        if (response.versions.isEmpty) return;

        final latestAck = getLatestAcknowledgedVersion() ?? '1.0.0';
        if (!response.mustUpdate &&
            latestAck.compareTo(response.versions.first.semver) >= 0) return;

        acknowledgeUpdateBanner(response.firstNotMandatory);
        await showDialog(
          context: context,
          barrierDismissible: !response.mustUpdate,
          builder: (context) {
            return NewVersionDialog(updates: response);
          },
        );
      }
    }).catchError((e, st) {
      debugPrint('Error getting pending updates: $e\n$st');
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
