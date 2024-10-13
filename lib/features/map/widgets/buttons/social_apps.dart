import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri facebookUrl = Uri.parse('https://www.facebook.com/ContigoSanMarcos/');
final Uri tiktokUrl = Uri.parse('https://tiktok.com/@contigosanmarcos');
final Uri instagramUrl =
    Uri.parse('https://www.instagram.com/contigo_san.marcos/');

class SocialApps extends ConsumerWidget {
  const SocialApps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _launchUrl(Uri url) async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Facebook Button
        SizedBox(
          width: 18,
          height: 18,
          child: ElevatedButton(
            onPressed: () {
              _launchUrl(facebookUrl);
            },
            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/social_media/facebook.svg',
                  width: 18,
                  height: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Instagram Button
        SizedBox(
          width: 18,
          height: 18,
          child: ElevatedButton(
            onPressed: () {
              _launchUrl(instagramUrl);
            },
            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/social_media/instagram.svg',
                  width: 18,
                  height: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // TikTok Button
        SizedBox(
          width: 18,
          height: 18,
          child: ElevatedButton(
            onPressed: () {
              _launchUrl(tiktokUrl);
            },
            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/social_media/tiktok-icon.svg',
                  width: 18,
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
