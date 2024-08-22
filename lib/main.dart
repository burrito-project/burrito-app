import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:burrito/theme/burro_theme.dart';
import 'package:burrito/features/core/pages/index.dart';
import 'package:burrito/features/app_updates/wrappers/pending_updates_wrapper.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: colorThemes['primary'],
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: colorThemes['primary'],
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Contigo Burrito UNMSM',
        theme: BurritoMobileTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const SafeArea(
          child: PendingUpdatesWrapper(
            child: BurritoApp(),
          ),
        ),
      ),
    ),
  );
}
