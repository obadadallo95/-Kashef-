import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger_service.dart';

final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError('PreferencesService not initialized');
});

class PreferencesService {
  final SharedPreferences _prefs;
  final LogService _logger;

  static const String _keyBiometricEnabled = 'isBiometricEnabled';
  static const String _keyHasSeenOnboarding = 'hasSeenOnboarding';

  PreferencesService(this._prefs, this._logger);

  bool get isBiometricEnabled => _prefs.getBool(_keyBiometricEnabled) ?? false;
  
  bool get hasSeenOnboarding => _prefs.getBool(_keyHasSeenOnboarding) ?? false;

  Future<void> setBiometricEnabled(bool value) async {
    await _prefs.setBool(_keyBiometricEnabled, value);
    _logger.info('Biometric enabled set to: $value');
  }

  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_keyHasSeenOnboarding, value);
    _logger.info('Has seen onboarding set to: $value');
  }
}
