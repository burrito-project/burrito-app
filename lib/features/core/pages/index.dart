import 'package:burrito/features/map/widgets/bottom_bar/bottom_bar_footer_content.dart';
import 'package:burrito/features/map/widgets/buttons/go_user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/core/utils.dart';
import 'package:burrito/features/map/widgets/map_view.dart';
import 'package:burrito/features/notifications/widgets/web_sidebar.dart';
import 'package:burrito/features/core/providers/responsive_provider.dart';
import 'package:burrito/features/map/widgets/buttons/go_back_button.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/map/widgets/buttons/follow_burrito_button.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_web.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';

class BurritoApp extends ConsumerStatefulWidget {
  const BurritoApp({super.key});

  @override
  ConsumerState<BurritoApp> createState() => BurritoAppState();
}

class BurritoAppState extends ConsumerState<BurritoApp> {
  bool wideScreen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.sizeOf(context).width;
    wideScreen = width > 700;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wideScreenProvider.notifier).state = wideScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final expansion = ref.watch(bottomSheetExpansionProvider);
    final padding = wideScreen
        ? WebBurritoBottomAppBar.bottomBarHeight
        : screenFractionToPixelSize(expansion, context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 60,
                child: BottomBarFooterContent(),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: BurritoMap(),
                    ),
                    if (wideScreen) ...[
                      const WebSidebar(),
                    ]
                  ],
                ),
              ),
              if (wideScreen) ...[
                const WebBurritoBottomAppBar(),
              ] else ...[
                SizedBox(height: padding),
              ],
            ],
          ),
          Positioned(
            right: (wideScreen ? WebSidebar.maxWidth : 0) + 10,
            top: 80,
            child: const Column(
              children: [
                // 🗺️ User location button
                GoUserLocationMapButton(),
                SizedBox(
                  height: 20,
                ),
                // 📌 Only shown when the burrito is visible
                FollowBurritoMapButton(),
              ],
            ),
          ),
          // ↩️ Go back to UNMSM button
          Positioned(
            right: (wideScreen ? WebSidebar.maxWidth : 0) + 10,
            bottom: padding + 10,
            child: const GoBackMapButton(),
          ),
          // Bottom bar
          if (!wideScreen) ...[
            const MobileBurritoBottomAppBar(),
          ],
        ],
      ),
    );
  }
}
