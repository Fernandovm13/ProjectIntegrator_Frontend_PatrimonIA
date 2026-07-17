import 'package:flutter/services.dart';

/// Controls Android's secure-window flag.
///
/// When enabled, Android blocks screenshots, screen recording, and the
/// application preview shown in the recent-apps screen.
abstract final class ScreenSecurity {
  static const _channel = MethodChannel('patrimonia/screen_security');

  static Future<void> setSecure(bool enabled) async {
    try {
      await _channel.invokeMethod<void>('setSecure', {'enabled': enabled});
    } on MissingPluginException {
      // The native protection is Android-specific. This also keeps widget tests
      // and other unsupported platforms working normally.
    } on PlatformException {
      // Do not interrupt authentication if the platform cannot change the flag.
    }
  }
}
