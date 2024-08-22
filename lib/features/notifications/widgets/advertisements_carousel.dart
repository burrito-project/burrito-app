import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:burrito/features/map/providers/bottomsheet_provider.dart';
import 'package:burrito/features/map/widgets/bottom_bar/app_bottom_bar_mobile.dart';

class AdvertisementsCarousel extends ConsumerStatefulWidget {
  const AdvertisementsCarousel({super.key});

  @override
  ConsumerState<AdvertisementsCarousel> createState() =>
      AdvertisementsCarouselState();
}

class AdvertisementsCarouselState
    extends ConsumerState<AdvertisementsCarousel> {
  @override
  Widget build(BuildContext context) {
    final isBottomSheetExpanded = ref.watch(isBottomSheetExpandedProvider);

    return FlutterCarousel(
      options: CarouselOptions(
        height: kBottomAdvertismentHeight,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        viewportFraction: 0.98,
        disableCenter: true,
        showIndicator: false,
        padEnds: false,
        autoPlay: isBottomSheetExpanded,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(
          milliseconds: 500,
        ),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items: [
        'https://www.cocacolaep.com/assets/Australia/Vending-Microsite/Coke-Vending_About-Us-Banner__ScaleWidthWzE0NDBd.png',
        'https://filestage.io/wp-content/uploads/2023/11/Disney-banner-ad-1024x398.webp',
      ].map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              url,
              // fixed height, and crop to fit the width in the screen
              height: kBottomAdvertismentHeight,
              fit: BoxFit.cover,
            );
          },
        );
      }).toList(),
    );
  }
}
