import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/grove.dart';

class GroveProvider extends ChangeNotifier {
  late Box<Grove> _groveBox;
  List<Grove> _sessions = [];

  List<Grove> get sessions => List.unmodifiable(_sessions);
  int get completedSessions => _sessions.length;

  GroveProvider() {
    _init();
  }

  Future<void> _init() async {
    _groveBox = await Hive.openBox<Grove>('grove');
    _loadSessions();
  }

  void _loadSessions() {
    _sessions = _groveBox.values.toList();
    notifyListeners();
  }

  Future<void> addSession(int duration) async {
    final session = Grove(
      completedAt: DateTime.now(),
      duration: duration,
    );
    await _groveBox.put(session.id, session);
    _sessions.add(session);
    notifyListeners();
  }
}
