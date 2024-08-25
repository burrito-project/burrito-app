import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/notifications/utils.dart';
import 'package:burrito/features/app_updates/widgets/new_version_dialog.dart';
import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';

class NewAppUpdateButton extends ConsumerWidget {
  final PendingUpdatesResponse updates;

  const NewAppUpdateButton({
    super.key,
    required this.updates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        closeModalBottomSheet2(ref);

        if (!context.mounted) return;

        acknowledgeUpdateBanner(updates.firstNotMandatory);
        await showDialog(
          context: context,
          builder: (context) => NewVersionDialog(updates: updates),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          // rounded borders
          decoration: BoxDecoration(
            // color: const Color(0xff0f4d73),
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🎉 Versión ${updates.versions.first.semver} ya disponible 🎉',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Text(
                  'Toca para ver',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
