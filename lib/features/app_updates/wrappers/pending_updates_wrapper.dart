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

class PendingUpdatesWrapperState extends ConsumerState<PendingUpdatesWrapper> {
  @override
  void initState() {
    super.initState();

    if (kIsWeb) return; // web is (well, should be) always up to date

    getPendingUpdates().then((response) async {
      if (response.versions.isNotEmpty) {
        final packageInfo = await kPackageInfo;

        // show dialog
        if (!mounted) return;

        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('New version available!'),
                  Text('Current version: ${packageInfo.version}'),
                  Text('New version: ${response.versions.first}'),
                  ElevatedButton(
                    onPressed: () {
                      // open store
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
