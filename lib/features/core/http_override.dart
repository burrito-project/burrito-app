import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart' as io;

class MyHttpOverrides extends io.HttpOverrides {
  @override
  io.HttpClient createHttpClient(io.SecurityContext? context) {
    if (kIsWeb) {
      return throw UnimplementedError();
    }

    return super.createHttpClient(context)
      ..badCertificateCallback =
          (io.X509Certificate cert, String host, int port) => true;
  }
}
