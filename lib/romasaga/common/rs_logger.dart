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

  static void e(String message, dynamic e) {
    _logger.e(message, e);
  }
}
