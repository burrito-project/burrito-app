import 'package:burrito/features/map/widgets/app_bottom_bar_mobile.dart';
import 'package:burrito/features/map/widgets/buttons/follow_burrito_button.dart';
import 'package:burrito/features/map/widgets/buttons/go_back_button.dart';
import 'package:burrito/features/map/widgets/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/map/widgets/app_top_bar.dart';

class BurritoApp extends ConsumerStatefulWidget {
  const BurritoApp({super.key});

  @override
  ConsumerState<BurritoApp> createState() => BurritoAppState();
}

class BurritoAppState extends ConsumerState<BurritoApp> {
  final DraggableScrollableController _botomSheetController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const BurritoTopAppBar(),
              Expanded(
                child: BurritoMap(
                  botomSheetController: _botomSheetController,
                ),
              ),
              // const SizedBox(height: kBottomBarHeight - 12),
              // WebBurritoBottomAppBar(
              //   key: const Key('bottom_sheet'),
              //   controller: _botomSheetController,
              // ),
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
          MobileBurritoBottomAppBar(
            key: const Key('bottom_sheet'),
            controller: _botomSheetController,
          ),
        ],
      ),
    );
  }
}
