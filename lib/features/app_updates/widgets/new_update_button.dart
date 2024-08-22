import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';
import 'package:burrito/features/app_updates/widgets/new_version_dialog.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        ref.read(bottomSheetControllerProvider).animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );

        if (!context.mounted) return;

        await showDialog(
          context: context,
          builder: (context) => NewVersionDialog(updates: updates),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
