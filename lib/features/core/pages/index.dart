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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              BurritoTopAppBar(),
              Expanded(
                child: BurritoMap(),
              ),
              SizedBox(height: kBottomBarHeight - 12),
              // WebBurritoBottomAppBar(
              //   key: const Key('bottom_sheet'),
              //   controller: _botomSheetController,
              // ),
            ],
          ),
          Positioned(
            left: 10,
            bottom: kBottomBarHeight + 25,
            child: GoBackMapButton(),
          ),
          Positioned(
            right: 10,
            bottom: kBottomBarHeight + 5,
            child: FollowBurritoMapButton(),
          ),
          MobileBurritoBottomAppBar(
            key: Key('bottom_sheet'),
          ),
        ],
      ),
    );
  }
}
