import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:burrito/features/map/widgets/map_view.dart';
import 'package:burrito/theme/burro_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: colorThemes['primary'],
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burrito tracker',
      theme: BurritoMobileTheme.theme,
      home: const SafeArea(
        child: BurritoMap(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
