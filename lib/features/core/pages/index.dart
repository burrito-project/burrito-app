import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/map/widgets/map_view.dart';
import 'package:burrito/features/map/widgets/app_top_bar.dart';
import 'package:burrito/features/map/widgets/buttons/go_back_button.dart';
import 'package:burrito/features/map/widgets/buttons/follow_burrito_button.dart';
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

    if (kIsWeb) {
      final double width = MediaQuery.sizeOf(context).width;
      wideScreen = width > 600;
    } else {
      wideScreen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const BurritoTopAppBar(),
              const Expanded(
                child: BurritoMap(),
              ),
              if (!wideScreen) ...[
                const SizedBox(height: kBottomBarHeight - 12),
              ],
              if (wideScreen) ...[
                const WebBurritoBottomAppBar(
                  key: Key('bottom_sheet'),
                ),
              ],
            ],
          ),
          const Positioned(
            left: 10,
            bottom: kBottomBarHeight + 25,
            child: GoBackMapButton(),
          ),
          const Positioned(
            right: 10,
            bottom: kBottomBarHeight + 5,
            child: FollowBurritoMapButton(),
          ),
          if (!wideScreen) ...[
            const MobileBurritoBottomAppBar(
              key: Key('bottom_sheet'),
            ),
          ],
        ],
      ),
    );
  }
}
