import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'services/blocker_service.dart';
import 'app.dart';

// @pragma('vm:entry-point')
// void activateFlowstate() {
//   print("Alarm fired! Activating Deep Work Flowstate.");
//   final deepWorkApps = ['com.instagram.android', 'com.facebook.katana'];
//   final deepWorkWebsites = ['reddit.com', 'twitter.com'];

//   BlockerService.updateBlocklist(apps: deepWorkApps, websites: deepWorkWebsites);
// }

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await AndroidAlarmManager.initialize();
  runApp(const GeodeApp());
}
