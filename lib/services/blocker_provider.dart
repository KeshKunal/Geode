import 'package:flutter/material.dart';
import 'blocker_service.dart';

class BlockerProvider with ChangeNotifier {
  List<String> _blockedApps = ['com.instagram.android', 'com.facebook.katana'];
  List<String> _blockedWebsites = ['reddit.com', 'twitter.com'];

  List<String> get blockedApps => _blockedApps;
  List<String> get blockedWebsites => _blockedWebsites;

  void addApp(String packageName) {
    _blockedApps.add(packageName);
    notifyListeners();
  }

  void removeApp(String packageName) {
    _blockedApps.remove(packageName);
    notifyListeners();
  }
void addWebsites(String packageName) {
    _blockedWebsites.add(packageName);
    notifyListeners();
  }

  void removeWebsites(String packageName) {
    _blockedWebsites.remove(packageName);
    notifyListeners();
  }

  Future<void> activateBlocker() async {
    await BlockerService.updateBlocklist(
      apps: _blockedApps,
      websites: _blockedWebsites,
    );
    print("Blocker activated with: $_blockedApps and $_blockedWebsites");
  }

  Future<void> deactivateBlocker() async {
    await BlockerService.updateBlocklist(apps: [], websites: []);
    print("Blocker deactivated.");
  }
}

