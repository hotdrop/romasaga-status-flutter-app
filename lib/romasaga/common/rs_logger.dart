import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class RSLogger {
  const RSLogger._();

  static final Logger _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message, dynamic exception, StackTrace stackTrace) {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      _logger.d("クラッシュレポートを送ります");
      FirebaseCrashlytics.instance.setCustomKey("message", message);
      FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    } else {
      _logger.e(message, exception);
    }
  }
}
