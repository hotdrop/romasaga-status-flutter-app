import 'package:logger/logger.dart';

class RSLogger {
  static final Logger _logger = Logger();

  const RSLogger._();

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message, Exception e) {
    _logger.e(message, e);
  }
}
