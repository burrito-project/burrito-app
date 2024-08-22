import 'dart:convert';

import 'package:android_id/android_id.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class UserFingerprint {
  static String? _fingerPrint;
  static bool _loaded = false;

  /// Generates or retrieves the fingerprint.
  static String get() {
    if (!_loaded) {
      throw Exception('UserFingerprint not loaded');
    }
    return _fingerPrint!;
  }

  static Future<void> load() async {
    final fingerprint = await _getDeviceFingerprint();
    debugPrint('🆔 loaded fingerprint: $fingerprint');
    _fingerPrint = fingerprint;
    _loaded = true;
  }

  /// Generates a new fingerprint based on device-specific information.
  static Future<String> _getDeviceFingerprint() async {
    String? deviceIdentifier;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webInfo = await deviceInfo.webBrowserInfo;
      deviceIdentifier = (webInfo.vendor ?? '') +
          (webInfo.userAgent ?? '') +
          webInfo.hardwareConcurrency.toString();
    } else {
      if (Platform.isAndroid) {
        deviceIdentifier = await const AndroidId().getId();
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor;
      } else if (Platform.isLinux) {
        LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        deviceIdentifier = linuxInfo.machineId;
      }
    }
    return _hashString(deviceIdentifier ?? 'anonymous');
  }

  static String _hashString(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
