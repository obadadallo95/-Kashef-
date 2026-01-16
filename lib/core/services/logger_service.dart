import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Abstract class defining the Logging Service contract
abstract class LogService {
  void debug(String message, [dynamic error, StackTrace? stackTrace]);
  void info(String message);
  void warning(String message, [dynamic error, StackTrace? stackTrace]);
  void error(String message, dynamic error, StackTrace stackTrace);
}

/// Console implementation of the LogService using the `logger` package
class ConsoleLogger implements LogService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      
      // Correct parameter name for time
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  @override
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  @override
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void error(String message, dynamic error, StackTrace stackTrace) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}

/// Provider for the LogService
final loggerProvider = Provider<LogService>((ref) => ConsoleLogger());

/// Riverpod Observer to log state changes
final class RiverpodLogger extends ProviderObserver {
  final LogService _logger;

  RiverpodLogger(this._logger);

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final provider = context.provider;
    _logger.debug(
      'Riverpod: ${provider.name ?? provider.runtimeType}\n'
      '   Old: $previousValue\n'
      '   New: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    final provider = context.provider;
    _logger.debug('Riverpod: Provider Added: ${provider.name ?? provider.runtimeType} value: $value');
  }
}
