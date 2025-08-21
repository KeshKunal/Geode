import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroveProvider with ChangeNotifier {
  int _completedSessions = 0;
  static const String _sessionKey = 'completedSessions';

  int get completedSessions => _completedSessions;

  GroveProvider() {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    _completedSessions = prefs.getInt(_sessionKey) ?? 0;
    notifyListeners();
  }

  Future<void> addSession() async {
    final prefs = await SharedPreferences.getInstance();
    _completedSessions++;
    await prefs.setInt(_sessionKey, _completedSessions);
    notifyListeners();
  }
}
