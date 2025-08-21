import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:geode/services/blocker_provider.dart';
import 'package:geode/services/grove_provider.dart';
import 'package:provider/provider.dart';
import 'services/blocker_service.dart';
import 'models/task.dart';
import 'providers/task_manager.dart';
import 'app.dart';

// @pragma('vm:entry-point')
// void activateFlowstate() {
//   print("Alarm fired! Activating Deep Work Flowstate.");
//   final deepWorkApps = ['com.instagram.android', 'com.facebook.katana'];
//   final deepWorkWebsites = ['reddit.com', 'twitter.com'];

//   BlockerService.updateBlocklist(
//       apps: deepWorkApps, websites: deepWorkWebsites);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await AndroidAlarmManager.initialize();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskManager()),
        ChangeNotifierProvider(create: (_) => BlockerProvider()),
        ChangeNotifierProvider(create: (_) => GroveProvider()),
      ],
      child: const GeodeApp(),
    ),
  );
}
