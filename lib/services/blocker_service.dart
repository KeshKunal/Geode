import 'package:flutter/services.dart';

class BlockerService {
  static const platform = MethodChannel('com.example.geode/accessibility');

  static Future<void> updateBlocklist({
    required List<String> apps,
    required List<String> websites,
  }) async {
    try {
      await platform.invokeMethod('updateBlocklist', {
        'apps': apps,
        'websites': websites,
      });
    } on PlatformException catch (e) {
      print("Failed to update blocklist: ${e.message}");
    }
  }
}
