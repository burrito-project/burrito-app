import 'package:localstorage/localstorage.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:burrito/theme/burro_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burrito/features/core/pages/index.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:burrito/features/app_updates/wrappers/pending_updates_wrapper.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  HttpOverrides.global = MyHttpOverrides();
  await initLocalStorage();

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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
