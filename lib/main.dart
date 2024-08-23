import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:burrito/theme/burro_theme.dart';
import 'package:burrito/services/dio_client.dart';
import 'package:burrito/features/core/fingerprint.dart';
import 'package:burrito/features/core/pages/index.dart';
import 'package:burrito/features/core/http_override.dart'
    if (dart.library.html) 'package:burrito/features/core/http_override_web.dart';
import 'package:burrito/features/app_updates/wrappers/pending_updates_wrapper.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if (!kIsWeb) {
    HttpOverrides.global = MyHttpOverrides();
  }
  await initLocalStorage();
  await UserFingerprint.load();

  registerSession();

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

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);

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
