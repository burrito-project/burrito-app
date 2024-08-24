import 'package:burrito/features/app_updates/entities/pending_updates_response.dart';
import 'package:burrito/features/app_updates/entities/remote_version.dart';
import 'package:burrito/features/core/widgets/custom_divider.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersionDialog extends ConsumerWidget {
  final PendingUpdatesResponse updates;

  const NewVersionDialog({
    super.key,
    required this.updates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: !updates.mustUpdate,
      onPopInvokedWithResult: (result, _) {},
      child: Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              height: constraints.maxHeight - 60 - 20 - 4,
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
                                          Row(
                                            children: [
                                              Text(
                                                'v${update.semver}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              // urgent tag
                                              if (update.isMandatory) ...[
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: const Text(
                                                    'Obligatorio',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
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
                            const SizedBox(height: 4),
                            FutureBuilder(
                              future: kPackageInfo,
                              builder: (ctx, snapshot) {
                                if (!snapshot.hasData) {
                                  return const SizedBox.shrink();
                                }
                                final packageInfo = snapshot.data!;

                                return SizedBox(
                                  height: 20,
                                  child: Text(
                                    'Versión actual: v${packageInfo.version}',
                                    style: const TextStyle(
                                      color: Colors.white30,
                                      fontSize: 14,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 60,
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(10).copyWith(top: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        // open store
                                        if (updates.mustUpdate) {
                                          openAreYouSureDialog(context);
                                          return;
                                        }
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
                                      onPressed: () async {
                                        // open store
                                        await openPlayStore();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff0f4d73),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
            },
          ),
        ),
      ),
    );
  }

  Future<void> openPlayStore() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId = Platform.isAndroid
          ? 'com.contigosanmarcos.burritoapp'
          : 'io.github.proyectitos-fisi.burrito';
      final url = Uri.parse(
        Platform.isAndroid
            ? "market://details?id=$appId"
            : "https://apps.apple.com/app/id$appId",
      );
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  void openAreYouSureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Advertencia'),
          content: const Text(
            'Si no actualizas esta versión la app podría no funcionar correctamente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Volver',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Actualizar más tarde',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

void acknowledgeUpdateBanner(RemoteAppVersionInfo? version) {
  if (version == null) return;
  if (version.isMandatory) return;
  localStorage.setItem(kLatestAcknowledgedVersion, version.semver);
}

String? getLatestAcknowledgedVersion() {
  return localStorage.getItem(kLatestAcknowledgedVersion);
}

const kLatestAcknowledgedVersion = 'latest_acknowledged_version';
