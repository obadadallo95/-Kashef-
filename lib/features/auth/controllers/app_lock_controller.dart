import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/services/preferences_service.dart';

class AppLockState {
  final bool isLocked;
  final bool isEnabled;

  const AppLockState({this.isLocked = false, this.isEnabled = false});

  AppLockState copyWith({bool? isLocked, bool? isEnabled}) {
    return AppLockState(
      isLocked: isLocked ?? this.isLocked,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

final appLockControllerProvider = NotifierProvider<AppLockController, AppLockState>(AppLockController.new);

class AppLockController extends Notifier<AppLockState> {
  late final BiometricService _biometricService;
  late final PreferencesService _preferencesService;

  @override
  AppLockState build() {
    _biometricService = ref.read(biometricServiceProvider);
    _preferencesService = ref.read(preferencesServiceProvider);
    
    final enabled = _preferencesService.isBiometricEnabled;
    return AppLockState(isEnabled: enabled, isLocked: enabled); // Lock if enabled on start
  }

  Future<bool> authenticate() async {
    if (!state.isLocked) return true;

    final success = await _biometricService.authenticate();
    if (success) {
      state = state.copyWith(isLocked: false);
    }
    return success;
  }

  void lockApp() {
    if (state.isEnabled) {
      state = state.copyWith(isLocked: true);
    }
  }
  
  Future<bool> enableBiometrics() async {
    final supported = await _biometricService.isDeviceSupported();
    if (!supported) return false;

    final success = await _biometricService.authenticate();
    if (success) {
      await _preferencesService.setBiometricEnabled(true);
      state = state.copyWith(isEnabled: true);
      return true;
    }
    return false;
  }

  Future<void> disableBiometrics() async {
    await _preferencesService.setBiometricEnabled(false);
    state = state.copyWith(isEnabled: false, isLocked: false);
  }
}
