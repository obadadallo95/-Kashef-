import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import 'logger_service.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService(LocalAuthentication(), ref.read(loggerProvider)); 
});

class BiometricService {
  final LocalAuthentication _auth;
  final LogService _logger;

  BiometricService(this._auth, this._logger);

  Future<bool> isDeviceSupported() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } on PlatformException catch (e, stack) {
      _logger.error('Error checking device support', e, stack);
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
      );
      
      _logger.info('Authentication result: $didAuthenticate');
      return didAuthenticate;
    } on PlatformException catch (e, stack) {
       _logger.error('Error during authentication', e, stack);
      return false;
    }
  }
}
