import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  FirebaseAnalytics? _analytics;
  FirebaseCrashlytics? _crashlytics;
  bool _initialized = false;

  FirebaseService() {
    _init();
  }

  void _init() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _analytics = FirebaseAnalytics.instance;
        
        if (!kIsWeb) {
          _crashlytics = FirebaseCrashlytics.instance;
        }
        _initialized = true;
      }
    } catch (e) {
      print('Inicjalizacja FirebaseService nie powiodła się: $e');
    }
  }

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    if (!_initialized || _analytics == null) return;
    try {
      await _analytics!.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      print('Nie udało się zalogować: $e');
    }
  }

  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_initialized || _analytics == null) return;
    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
    } catch (e) {
      print('Nie udało wyświetlić widoku ekranu: $e');
    }
  }

  Future<void> recordError(dynamic exception, StackTrace? stack, {dynamic reason, bool fatal = false}) async {
    if (!_initialized || _crashlytics == null) return;
    try {
      await _crashlytics!.recordError(exception, stack, reason: reason, fatal: fatal);
    } catch (e) {
      print('Nie udało się zarejestrować błędu: $e');
    }
  }

  Future<void> setUserIdentifier(String identifier) async {
    if (!_initialized) return;
    try {
      if (_analytics != null) {
        await _analytics!.setUserId(id: identifier);
      }
      if (_crashlytics != null) {
        await _crashlytics!.setUserIdentifier(identifier);
      }
    } catch (e) {
      print('Nie udało się ustawić identyfikatora użytkownika: $e');
    }
  }
}
