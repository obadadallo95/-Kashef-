import 'package:shake/shake.dart';
import 'package:flutter/material.dart';
import '../../features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/logger_service.dart';

// Provider for PanicService
final panicServiceProvider = Provider<PanicService>((ref) {
  return PanicService(ref);
});

class PanicService {
  final Ref _ref;
  ShakeDetector? _detector;

  PanicService(this._ref);

  void startListening(BuildContext context) {
    _detector = ShakeDetector.autoStart(
      onPhoneShake: (_) {
        _triggerPanicMode(context);
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  void stopListening() {
    _detector?.stopListening();
  }

  void _triggerPanicMode(BuildContext context) {
    final logger = _ref.read(loggerProvider);
    logger.warning("🚨 PANIC MODE TRIGGERED! 🚨");

    // 1. Clear Analysis State (RAM Wipe)
    _ref.read(homeControllerProvider.notifier).reset();

    // 2. Navigate to Safe Screen (Settings or just pop everything)
    // We pop until connection, or go to a neutral screen.
    // Let's go to Settings as a "cover".
    if (context.mounted) {
       context.go('/'); // Reset to home first (cleared)
       // context.push('/settings'); // Optional: Go to settings
       
       // Show feedback
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(
           content: Text("Panic Mode Activated: Data Cleared."),
           backgroundColor: Colors.red,
           duration: Duration(seconds: 1),
         ),
       );
    }
  }
}
