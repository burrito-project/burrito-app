import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';
import 'package:burrito/features/core/widgets/custom_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store_redirect/store_redirect.dart';

class NewVersionDialog extends ConsumerWidget {
  final PendingUpdatesResponse updates;

  const NewVersionDialog({
    super.key,
    required this.updates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight * 0.40,
              maxHeight: constraints.maxHeight * 0.60,
              // maxWidth: 30.0,
              minWidth: double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  child: Text(
                    updates.versions.length > 1
                        ? 'Actualizaciones disponibles'
                        : 'Actualización disponible',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ),
                const CustomDivider(height: 2),
                Flexible(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          height: constraints.maxHeight - 60,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: updates.versions.length,
                            itemBuilder: (ctx, index) {
                              final update = updates.versions[index];

                              return Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 14),
                                      Text(
                                        'v${update.semver}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      if (update.bannerUrl != null) ...[
                                        const SizedBox(height: 8),
                                        CachedNetworkImage(
                                          imageUrl: update.bannerUrl!,
                                          cacheKey: update.bannerUrl!,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(height: 2),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        update.releaseNotes,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      if (index !=
                                          updates.versions.length - 1) ...[
                                        const CustomDivider(height: 6),
                                      ],
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const CustomDivider(height: 0),
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    // open store
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Más tarde',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // open store
                                    StoreRedirect.redirect();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff0f4d73),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Actualizar',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
